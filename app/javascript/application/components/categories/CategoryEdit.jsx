import React from 'react'

import { Link } from 'react-router-dom'
import { Breadcrumb } from 'react-bootstrap'
import CategoryForm from './CategoryForm'

const CategoryEdit = (props) => (
    <div>
        <h1>Редактирование категории</h1>
        <Breadcrumb className={'row'}>
            <li><Link to='/categories'>Категории</Link></li>
            <li className={'active'}>Редактирование категории</li>
        </Breadcrumb>
        <CategoryForm {...props} />
    </div>
);

export default CategoryEdit;