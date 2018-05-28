import React from 'react';
import { BrowserRouter, Switch } from 'react-router-dom'

import RouteWithLayout from '../MainLayout'

import Home from '../Home'
import Node from '../Node'

export default class MyComponent extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (<BrowserRouter>
            <div>

                {/* ROUTES */}
                <Switch>
                  <RouteWithLayout exact={true} path="/node/:nodeName" component={Node}/>
                  <RouteWithLayout exact={true} path="/" component={Home}/>
                </Switch>


            </div>
        </BrowserRouter>)
    }
}
