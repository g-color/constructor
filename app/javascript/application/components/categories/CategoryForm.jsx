import React       from 'react'
import axios       from 'axios';
import queryString from 'query-string'

import { Link } from 'react-router-dom'
import { Row, Col, Button, FormGroup, ControlLabel, Form, FormControl, Checkbox } from 'react-bootstrap'
import { cloneDeep, isObject } from 'lodash';

import FieldGroup from '../../helpers/FieldGroup'
import CheckboxGroup from '../../helpers/CheckboxGroup'

export default class CategoryForm extends React.Component {
	constructor(props) {
		super(props);

        let queryParams = queryString.parse(props.location.search);
		this.state = {
			category: {
			    id:      null,
                name:    '',
                product: queryParams.product === 'true'
            },
            category_errors: {}
		};

		this.sendCategory  = this.sendCategory.bind(this);
		this.handleChange  = this.handleChange.bind(this);
        this.fetchCategory = this.fetchCategory.bind(this);
	}

    fetchCategory(id) {
        axios.get(`/api/categories/${id}`)
            .then(response => {
                this.setState({category: response.data})
            })
            .catch(error => {
                console.error(error)
            })
    }

    componentWillMount() {
	    if (this.props.match.params.id) {
            this.fetchCategory(this.props.match.params.id)
        }
    }

	handleChange(e) {
        let category = cloneDeep(this.state.category);
        category[e.target.name] = e.target.name === 'product' ? e.target.checked : e.target.value;
        this.setState({category: category})
    }

	sendCategory(e) {
        let request;
	    e.preventDefault();
	    if (this.state.category.id) {
	        request = axios.put(`/api/categories/${this.state.category.id}`, this.state.category)
        }
        else {
            request = axios.post(`/api/categories`, this.state.category)
        }
        request.then(response => {
            if (isObject(response.data)) {
                this.setState({category_errors: response.data})
            }
            else {
                this.props.history.push('/categories')
            }
        })
        .catch(error => {
            console.error(error)
        })
    }

    render() {
		return (
			<div>
                <Form onSubmit={this.sendCategory}>
                    <Row className={'action-buttons'}>
                        <Link to='/categories' className={'btn btn-default'}>Отмена</Link>
                        <Button type='submit' bsStyle='success' className='pull-right'>Сохранить</Button>
                    </Row>
                    <br/>
                    <Row className='main-content'>
                        <div className={'col-sm-offset-2 col-sm-8'}>
                            <FieldGroup
                                id="name"
                                name="name"
                                label="Наименование"
                                required={true}
                                onChange={this.handleChange}
                                value={this.state.category.name}
                                validation={this.state.category_errors['name'] ? 'error' : null}
                            />
                            <CheckboxGroup
                                id="product"
                                name="product"
                                label="Для сметных продуктов"
                                checked={this.state.category.product}
                                onChange={this.handleChange}
                            />
                        </div>
                    </Row>
                </Form>
			</div>
		)
	}
}