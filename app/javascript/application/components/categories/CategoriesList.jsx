import React from 'react'
import axios from 'axios';
import _     from 'lodash';

import { Link } from 'react-router-dom'
import { Table, Button, ButtonGroup, FormControl } from 'react-bootstrap'

export default class CategoriesList extends React.Component {
	constructor(props) {
		super(props);
		this.state = {
			categories: [],
			grouped: {true: [], false: []},
			tables: [
				{id: 1, product: false,  collection: [], title: 'Категории для примитивов и объектов' },
			    {id: 2, product: true, collection: [], title: 'Категории для сметных продуктов'}
		    ],

		};
		this.renderCategories = this.renderCategories.bind(this);
		this.renderCategory = this.renderCategory.bind(this);
	}

	fetchCategories() {
		axios.get(`api/categories`)
			.then(response => {
				this.setState({
					categories: response.data,
					grouped: _.groupBy(response.data, (category) => category.product)
				})
			})
			.catch(error => {
				console.error(error)
			})
	}

	renderCategories() {
		return this.state.tables.map((table) =>
			<Table key={table.id} hover responsive>
			    <thead>
			      <tr>
			        <th className={'col-sm-9 text-center'}>{table.title}</th>
			        <th className={'col-sm-3 text-center'}>
						<Link to={`/categories/new?product=${table.product ? 'true' : 'false'}`}
                              style={{display:'inline'}}
                              className={'btn btn-sm btn-primary'}>Добавить</Link>
		        	</th>
			      </tr>
			    </thead>
			    <tbody>
			      	{this.renderCategory(table)}
			    </tbody>
			</Table>
		)
	}

	renderCategory(table) {
		return this.state.grouped[table.product].map((category) =>
			<tr key={category.id}>
				<td>{category.name}</td>
				<td className={'text-center'}>
                    <Link to={`/categories/${category.id}/edit`} style={{color:'#fff'}}>
                        <Button bsStyle="warning">
                            <i className={'fa fa-pencil'} />
                        </Button>
                    </Link>
                    <Button bsStyle="danger" style={{color:'#fff'}}>
                        <i className={'fa fa-trash'} />
                    </Button>
		 		</td>
		 	</tr>
		)
	}

	componentWillMount() {
		this.fetchCategories()
	}

	render() {
		return (
			<div>
				<h1>Категории</h1>
				<br />
				<div className={'row main-content col-sm-offset-1 col-sm-10'}>
					{this.renderCategories()}
				</div>
			</div>
		)	
	}
}