import React from 'react';
import { BrowserRouter, Route,  Switch } from 'react-router-dom'

import RouteWithLayout from '../MainLayout'

import Home from '../Home'
import Node from '../Node'
import Nodes from '../Nodes'

export default class AppView extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (<BrowserRouter>
            <div>

                {/* ROUTES */}
                <Switch>
                  <RouteWithLayout exact={true} path="/node/:nodeName" component={Node}/>
                  <RouteWithLayout exact={true} path="/nodes" component={Nodes}/>
                  <RouteWithLayout exact={true} path="/" component={Home}/>
                </Switch>


            </div>
        </BrowserRouter>)
    }
}
