import React from 'react'
import axios from 'axios'
import { Link } from 'react-router-dom'
import { Alert, Row, Col, NavDropdown, Navbar, Nav, MenuItem, NavItem, Button } from 'react-bootstrap'
import _ from 'lodash'
import getMetaContent from '../helpers/getMetaContent'

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

  signOut() {
    axios.delete('/signout', {
        authenticity_token: getMetaContent("csrf-token")
      })
      .then(function (response) {
        location.reload();
      })
      .catch(error => {
        location.reload();
        console.error(error)
      })
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
            <NavItem href="/clients">Клиенты</NavItem>
            <NavItem href="/solutions">Готовые решения</NavItem>
          </Nav>
          <Nav pullRight>
            <NavItem href={`/users/${this.state.user.id}/edit`}>
                {`${this.state.user.last_name} ${this.state.user.first_name}`}
            </NavItem>
            {this.state.signed_in  && <NavItem href="#" onClick={this.signOut}>Выйти</NavItem>}
            {!this.state.signed_in && <NavItem href="#">Войти</NavItem>}
          </Nav>
        </Navbar.Collapse>
      </Navbar> 
    )
  }
}
