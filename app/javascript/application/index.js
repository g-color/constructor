import React from 'react'
import ReactDOM from 'react-dom'
import App from './components/App'
import { BrowserRouter } from 'react-router-dom';

import '../src/application.scss'

const root = document.querySelector('#root')
ReactDOM.render((
  <BrowserRouter>
    <App alertMessage={root.dataset.alert} 
    	 noticeMessage={root.dataset.notice} />
  </BrowserRouter>
), root)
