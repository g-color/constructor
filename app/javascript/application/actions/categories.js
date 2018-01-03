export const getCategories = categories => {
    return {
        type: 'GET_CATEGORIES',
        categories
    }
};

export const getCategory = category => {
    return {
        type: 'GET_CATEGORY',
        category
    }
};

export const saveCategory = (id, name, product) => {
    return {
        type: 'SAVE_CATEGORY',
        id, name, product
    }
};

export const deleteCategory = id => {
    debugger;
    return {
        type: 'DELETE_CATEGORY',
        id
    }
};
