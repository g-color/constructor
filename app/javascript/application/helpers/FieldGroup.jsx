import React from 'react'
import { FormGroup, ControlLabel, FormControl, HelpBlock } from 'react-bootstrap'

const FieldGroup = ({ id, label, help, collection, validation, ...props }) => (
    <FormGroup controlId={id} validationState={validation}>
        <ControlLabel>
            {props.required && <abbr title="Обязательное">*</abbr>} {label}
        </ControlLabel>
        <FormControl {...props}>
            {collection && collection.map((object) =>
                <option key={object.id} value={object.id}>{object.name}</option>
            )}
        </FormControl>
        {help && <HelpBlock>{help}</HelpBlock>}
    </FormGroup>
);

export default FieldGroup;