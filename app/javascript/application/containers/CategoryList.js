import { connect } from 'react-redux'

import List from '../components/categories/List'

const mapStateToProps = state => {
    return {
        categories: state.categories.collection,
    }
};

const mapDispatchToProps = dispatch => {
    return {
        dispatch: (action) => {
            dispatch(action)
        },
        onRemove: id => {
            dispatch(deleteCategory(id))
        }
    }
};

const CategoryList = connect(
    mapStateToProps,
    mapDispatchToProps
)(List);

export default CategoryList