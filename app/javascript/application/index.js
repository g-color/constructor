import React from 'react'
import { render } from 'react-dom'
import { BrowserRouter } from 'react-router-dom';
import { createStore } from 'redux'
import { Provider } from 'react-redux'
import constructorApp from './reducers'
import App from './components/App'

import '../src/application.scss'

const store = createStore(constructorApp, {
    categories: {
        collection: []
    }
});
const root = document.querySelector('#root');
render(
    <Provider store={store}>
        <BrowserRouter>
            <App alertMessage={root.dataset.alert}
                 noticeMessage={root.dataset.notice} />
        </BrowserRouter>
    </Provider>,
    root
);
