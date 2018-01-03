import React     from 'react'
import PropTypes from 'prop-types'
import { Link }  from 'react-router-dom'
import { Table } from 'react-bootstrap'
import Category  from './Category'

const Type = ({name, product, categories, dispatch}) => (
    <Table hover responsive>
        <thead>
        <tr>
            <th className={'col-sm-9 text-center'}>{name}</th>
            <th className={'col-sm-3 text-center'}>
                <Link to={`/categories/new?product=${product ? 'true' : 'false'}`}
                      style={{display:'inline'}}
                      className={'btn btn-sm btn-primary'}>Добавить</Link>
            </th>
        </tr>
        </thead>
        <tbody>
        {categories.map(category => (
            <Category key={category.id} {...category} dispatch={dispatch} />
        ))}
        </tbody>
    </Table>
);

Type.propTypes = {
    name: PropTypes.string.isRequired,
    product: PropTypes.bool.isRequired,
    categories: PropTypes.arrayOf(
        PropTypes.shape({
            id: PropTypes.number.isRequired,
            name: PropTypes.string.isRequired
        }).isRequired
    ).isRequired,
};

export default Type