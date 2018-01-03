import React          from 'react'
import PropTypes from 'prop-types'


import axios          from 'axios';
import _              from 'lodash';
import getMetaContent from '../../helpers/getMetaContent'


import { Link } from 'react-router-dom'
import { Table, Button, ButtonGroup, FormControl } from 'react-bootstrap'

import {filter} from 'lodash'
import Type from "./Type";
import {getCategories} from "../../actions/categories"

const categoryTypes = [
    {name: 'Категории для примитивов и объектов', product: false},
    {name: 'Категории для сметных продуктов', product: true}
];

class List extends React.Component {
    constructor(props) {
        super(props);
        this.categoriesByType = this.categoriesByType.bind(this);
    }

    componentWillMount() {
        let dispatch = this.props.dispatch;
        axios.get(`/api/categories`)
            .then(response => {
                dispatch(getCategories(response.data))
            })
            .catch(error => {
                console.error(error)
            });
    }

    categoriesByType(product) {
        return filter(this.props.categories, category => category.product === product)
    }


    render() {
        return (
            <div>
                <h1>Категории</h1>
                <br />
                <div className={'row main-content col-sm-offset-1 col-sm-10'}>
                    {categoryTypes.map((type, id) => (
                        <Type key={id} name={type.name} product={type.product}
                              dispatch={this.props.dispatch}
                              categories={this.categoriesByType(type.product)}/>
                    ))}
                </div>
            </div>
        );
    }
}

List.propTypes = {
    categories: PropTypes.array.isRequired,
    onRemove: PropTypes.func.isRequired
};

export default List;