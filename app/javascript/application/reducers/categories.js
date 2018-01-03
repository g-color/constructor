import { cloneDeep, remove } from 'lodash'

const categories = (state = [], action) => {
    let clonedState = cloneDeep(state);
    switch (action.type) {
        case 'GET_CATEGORY':
            return Object.assign({}, state, {item: action.category});
        case 'GET_CATEGORIES':
            return Object.assign({}, state, {collection: action.categories});
        case 'ADD_CATEGORY':
            clonedState.collection.push({
                id: action.id,
                name: action.name,
                product: action.product
            });
            return clonedState;
        case 'UPDATE_CATEGORY':
            return clonedState.collection.map(category =>
                (category.id === action.id)
                ? {...category, name: action.name, product: action.product}
                : category
            );
        case 'DELETE_CATEGORY':
            debugger;
            remove(clonedState.collection, category => category.id === action.id);
            return clonedState;
        default:
            return state
    }
};

export default categories
