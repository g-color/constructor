import React from 'react'
import {Popover, Tooltip, Modal, Button, OverlayTrigger} from 'react-bootstrap'
import _ from 'lodash'

export default class RemoveDialog extends React.Component {
    constructor(props) {
        super(props);
        debugger;
        this.state = {
            show: true
        };
    }

    close() {
        this.setState({ show: false });
    }

    open() {
        this.setState({ show: true });
    }

    render() {
        return (
            <Modal show={this.state.showModal} onHide={this.close}>
                <Modal.Header closeButton>
                    <Modal.Title>Удаление {this.props.type}</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <p>Вы действительно хотите удалить {this.props.type} <b>{this.props.name}</b></p>
                </Modal.Body>
                <Modal.Footer>
                    <Button onClick={this.props.onRemove}>Close</Button>
                    <Button onClick={this.close}>Close</Button>
                </Modal.Footer>
            </Modal>
        )

    }
}
