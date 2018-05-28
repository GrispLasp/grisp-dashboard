import React, {PropTypes} from 'react';

// import Footer from './Footer'
import Sidebar from './Sidebar'

import {Route} from 'react-router-dom'

const RouteWithLayout = ({
    component: Component,
    ...rest
}) => {
      return (<Route {...rest} render={props => {
              return (
                      <div id="layout">
                        <Sidebar {...props}/>
                        <Component {...props}/>
                      </div>
                    )
          }}/>)

};

export default RouteWithLayout;
