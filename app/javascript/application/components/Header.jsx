import React from 'react'
import axios from 'axios'
import { Link } from 'react-router-dom'
import { Alert, Row, Col, NavDropdown, Navbar, Nav, MenuItem, NavItem } from 'react-bootstrap'
import _ from 'lodash'

import logo from '../../images/logo.png'

export default class Header extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      alert:     props.alertMessage,
      notice:    props.noticeMessage,
      signed_in: _.isObject(gon.current_user),
      user:      gon.current_user,
    };

    this.signOut = this.signOut.bind(this);
  }

  componentWillMount() {
    var self = this
    axios.get('/auth/signed_in')
      .then(function (response) {
        self.setState(response.data);
      })
      .catch(error => {
        console.error(error)
      })
  }

  signOut() {
    var instance = axios.create({
      headers: {'X-CSRF-Token': this.getMetaContent("csrf-token")}
    });
    instance.delete('/users/sign_out.json', {
        authenticity_token: this.getMetaContent("csrf-token")
      })
      .then(function (response) {
        location.reload();
      })
      .catch(error => {
        console.error(error)
      })
  }

  getMetaContent(name) {
    var metas = document.getElementsByTagName('meta');
    for (var i=0; i<metas.length; i++) {
      if (metas[i].getAttribute("name") == name) {
        return metas[i].getAttribute("content");
      }
    }
    return "";
  }

  render() {
    return(
      <Navbar>
        <Navbar.Header>
          <Navbar.Brand>
            <a href="/">
              <img src={logo} className="logo"/>   
            </a>
          </Navbar.Brand>
          <Navbar.Toggle />
        </Navbar.Header>
        <Navbar.Collapse>
          <Nav>
            <NavDropdown title="Администрирование" id="basic-nav-dropdown">
              <MenuItem href="/primitives">Примитивы</MenuItem>
              <MenuItem href="/composites">Объекты</MenuItem>
              <MenuItem href="/products">Сметные продукты</MenuItem>
              <MenuItem divider />
              <li><Link to='/categories'>Категории</Link></li>
              <MenuItem href="/units">Единицы измерения</MenuItem>
              <li><Link to='/expenses'>Административные расходы</Link></li>
              <MenuItem divider />
              <MenuItem href="/users">Пользователи</MenuItem>
              <MenuItem href="/audits">История изменений</MenuItem>
              <MenuItem href="/reports">Отчеты</MenuItem>
            </NavDropdown>
            <NavItem href="#">Клиенты</NavItem>
            <NavItem href="#">Готовые решения</NavItem>
          </Nav>
          <Nav pullRight>
            <NavItem href="#">{`${this.state.user.last_name} ${this.state.user.first_name}`}</NavItem>
            {this.state.signed_in  && <NavItem href="#">Выйти</NavItem>}
            {!this.state.signed_in && <NavItem href="#">Войти</NavItem>}
          </Nav>
        </Navbar.Collapse>
      </Navbar> 
    )
  }
}
