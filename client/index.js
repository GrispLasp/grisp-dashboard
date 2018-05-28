import 'babel-polyfill'
import React from 'react';
import ReactDOM from 'react-dom';
import App from './app/components/App';
import { AppContainer } from 'react-hot-loader'
import './public/css/main.scss';

const render = Component => {
  ReactDOM.render(
    <AppContainer>
      <Component />
    </AppContainer>,
    document.getElementById('root'),
  )
}

render(App)

if (module.hot) {
    module.hot.accept(() => {
        render(App)
    })
}
