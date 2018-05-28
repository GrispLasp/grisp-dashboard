import React from 'react';
import {Provider} from 'react-redux';
import AppView from './AppView';
import store from '../../../store';
require('es6-promise').polyfill();


export default class AppContainer extends React.Component {
    constructor(props) {
        super(props);

    }
    render() {
        return (<Provider store={store}>
            <AppView/>
        </Provider>)
    }
}
