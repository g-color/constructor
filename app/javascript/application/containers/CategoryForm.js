import { connect } from 'react-redux'
import Container from '../components/categories/Container'

const mapStateToProps = state => {
    return {
        category: state.categories.item,
    }
};

const mapDispatchToProps = dispatch => {
    return {
        dispatch: (action) => {
            dispatch(action)
        }
    }
};

const CategoryForm = connect(
    mapStateToProps,
    mapDispatchToProps
)(Container);

export default CategoryForm