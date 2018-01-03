import React from 'react'
import axios from 'axios';
import { Link } from 'react-router-dom'
import { Breadcrumb } from 'react-bootstrap'
import { isObject, isUndefined } from 'lodash'
import { getCategory} from "../../actions/categories"

import Form from './Form'

class Container extends React.Component {
    constructor(props) {
        super(props);
    }

    componentWillMount() {
        let dispatch = this.props.dispatch;
        if (this.props.match && !isUndefined(this.props.match.params.id)) {
            axios.get(`/api/categories/${this.props.match.params.id}`)
            .then(response => {
                dispatch(getCategory(response.data))
            })
            .catch(error => {
                console.error(error)
            });
        }
    }

    render() {
        return (
            <div>
                <h1>{this.props.header}</h1>
                <Breadcrumb className={'row'}>
                    <li><Link to='/categories'>Категории</Link></li>
                    <li className={'active'}>
                        {isObject(this.props.category) ? this.props.category.name : 'Создание категории'}
                    </li>
                </Breadcrumb>
                <Form {...this.props} />
            </div>
        )
    }
}

export default Container