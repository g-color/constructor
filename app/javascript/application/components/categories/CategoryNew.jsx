import React from 'react'
import axios from 'axios';
import _     from 'lodash';

import { Link } from 'react-router-dom'
import { Breadcrumb } from 'react-bootstrap'
import CategoryForm from './CategoryForm'

export default class CategoryNew extends React.Component {
	constructor(props) {
		super(props);
		this.state = {
			category: null,
		};
	}

	render() {
		return (
			<div>
				<h1>Создание категории</h1>
				<Breadcrumb className={'row'}>
					<li><Link to='/categories'>Категории</Link></li>
					<li className={'active'}>Создание категории</li>
				</Breadcrumb>
                <CategoryForm {...this.props} />
			</div>
		)
	}
}