import React, {PropTypes} from 'react';

export default class HomeView extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (<div id="main">
            <div className="main-container">
                <h1>
                     Dashboard
                </h1>

                <p>
                  Welcome to the GRiSP Edge cluster Dashboard.
                </p>

            </div>
        </div>);
    }
}
