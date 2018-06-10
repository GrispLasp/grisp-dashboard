import React, {PropTypes} from 'react';

export default class OverviewView extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        const {node} = this.props;
        return (<div>
          <h1>
              Overview
          </h1>

            {
                node
                    ? <div>

                            {/* {JSON.stringify(node, null, 2)} */}

                            <p>Distributed node name: <b>{node.name}</b>
                            </p>

                        </div>
                    : null
            }

        </div>);
    }
}
