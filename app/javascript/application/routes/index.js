import React from 'react'
import { Switch, Route } from 'react-router-dom'

import CategoryForm from '../containers/CategoryForm'
import CategoryList from '../containers/CategoryList'

export const category = (props) => (
    <Switch>
        <Route exact path='/categories/new' render={(route) =>
            <CategoryForm header="Создание категории" {...props} {...route} />
        }/>
        <Route exact path='/categories/:id/edit' render={(route) =>
            <CategoryForm header="Редактирование категории" {...props} {...route} />
        }/>
        <Route exact path='/categories' component={CategoryList} />
    </Switch>
);
