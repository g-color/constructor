import React from 'react'
import { Switch, Route } from 'react-router-dom'

import CategoryNew    from './categories/CategoryNew'
import CategoryEdit   from './categories/CategoryEdit'
import CategoriesList from './categories/CategoriesList'

const Categories = (props) => (
  <Switch>
    <Route exact path='/categories/new'
           render={(routeProps) => <CategoryNew {...props} {...routeProps} />} />
    <Route exact path='/categories/:id/edit'
           render={(routeProps) => <CategoryEdit {...props} {...routeProps} />} />
    <Route exact path='/categories' 
           render={(routeProps) => <CategoriesList {...props} {...routeProps} />} />
  </Switch>
);

export default Categories