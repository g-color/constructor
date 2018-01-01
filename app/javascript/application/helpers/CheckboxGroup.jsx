import React from 'react'
import { FormGroup, ControlLabel, Checkbox, HelpBlock } from 'react-bootstrap'

const CheckboxGroup = ({id, label, checked, help, ...props}) => (
    <FormGroup controlId={id}>
        <Checkbox checked={checked} {...props}>
            {props.required && <abbr title="Обязательное">*</abbr>} {label}
        </Checkbox>
        {help && <HelpBlock>{help }</HelpBlock>}
    </FormGroup>
);

export default CheckboxGroup;