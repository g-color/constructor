import React from 'react'
import { Table, Button, FormControl } from 'react-bootstrap'
import axios from 'axios';
import _ from 'lodash';

export default class Expenses extends React.Component {
	constructor(props) {
		super(props);
		this.state = {
			expenses: [],
			total: 0
		};
		
		this.handleChange = this.handleChange.bind(this);
		this.updateExpenses = this.updateExpenses.bind(this);
	}

	fetchExpenses() {
		axios.get(`api/expenses`)
			.then(response => {
				let total = 0
				_.each(response.data, (expense) => {
					total += parseFloat(expense.percent)
				})
				this.setState({ 
					expenses: response.data, 
					total: total 
				})
			})
			.catch(error => {
				console.error(error)
			})
	}

	renderExpenses() {
		return this.state.expenses.map((expense) =>
			<tr key={expense.id}>
				<td>{expense.name}</td>
				<td>
					<FormControl
						type="number" 
						step="0.01"
						data-id={expense.id}
						value={expense.percent}
						onChange={this.handleChange}
					/>
				</td>
			</tr>
		)
	}

	updateExpenses() {
		_.each(this.state.expenses, (expense) => {
			axios.put(`api/expenses/${expense.id}`, {id: expense.id, percent: expense.percent})
				.catch(error => {
					console.error(error)
				})
		})
	}

	handleChange(e) {
		let expenses = _.cloneDeep(this.state.expenses)
		_.each(expenses, (expense) => {
			if (expense.id == e.target.dataset.id) {
				expense.percent = e.target.value.replace(/,/, '.')
			}
		})
		this.setState({expenses: expenses})
	}

	componentWillMount() {
		this.fetchExpenses()
	}

	render() {
		return (
			<div>
				<h1>Административные расходы</h1>
				<br />
				<div className={'row main-content col-sm-offset-2 col-sm-8'}>
					<Table hover responsive>
					    <thead>
					      <tr>
					        <th className={'col-sm-9'}>Наименование</th>
					        <th className={'col-sm-3 text-center'}>
					        	<Button style={{display:'inline'}} bsStyle="success" bsSize="small" onClick={this.updateExpenses}>Сохранить</Button>
				        	</th>
					      </tr>
					    </thead>
					    <tbody>
					      	{ this.renderExpenses() }
					    	<tr>
								<td><b>Итого:</b></td>
								<td className={'text-center'}>
									<b>{this.state.total}%</b>
								</td>
							</tr>
					    </tbody>
					</Table>
				</div>
			</div>
		)	
	}
}