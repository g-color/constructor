import React             from 'react'
import { Switch, Route } from 'react-router-dom'
import { Row, Col }      from 'react-bootstrap'

import Header     from './Header'
import Units      from './Units'
import Categories from './Categories'
import Expenses   from './Expenses'

const App = (props) => (
  <div>
    <Header token={getMetaContent}
            alertMessage={props.alertMessage}
            noticeMessage={props.noticeMessage} />
    <div className={'container'}>
        <Row style={{paddingTop: '1rem'}}>
          <Col lg={12}>
            <Switch>
              <Route path='/expenses'   component={Expenses} />
              <Route path='/categories' component={Categories} />
              <Route path='/units'      component={Units} />
              <Route exact path='/'     component={Units} />
            </Switch>
          </Col>
        </Row>
    </div>
  </div>
);

const getMetaContent = () => {
  var metas = document.getElementsByTagName('meta');
  for (var i=0; i<metas.length; i++) {
    if (metas[i].getAttribute("name") == name) {
      return metas[i].getAttribute("content");
    }
  }
  return "";
}

export default App
