import React      from 'react'
import PropTypes  from 'prop-types'
import axios      from 'axios'
import { Link }   from 'react-router-dom'
import { Button } from 'react-bootstrap'
import {deleteCategory} from '../../actions/categories'

const RemoveCategory = (id, dispatch) => {
    axios.delete(`/api/categories/${id}`)
        .then(response => {
            dispatch(deleteCategory(id))
        })
        .catch(error => {
            console.error(error)
        });
};

const Category = ({id, name, dispatch}) => (
    <tr key={id}>
        <td>{name}</td>
        <td className={'text-center'}>
            <Link to={`/categories/${id}/edit`} style={{color:'#fff'}}>
                <Button bsStyle="warning">
                    <i className={'fa fa-pencil'} />
                </Button>
            </Link>
            <Button bsStyle="danger"
                    style={{color:'#fff'}}
                    onClick={() => RemoveCategory(id, dispatch)}>
                <i className={'fa fa-trash'} />
            </Button>
        </td>
    </tr>
);

Category.propTypes = {
    dispatch: PropTypes.func.isRequired,
    id:       PropTypes.number.isRequired,
    name:     PropTypes.string.isRequired
};

export default Category