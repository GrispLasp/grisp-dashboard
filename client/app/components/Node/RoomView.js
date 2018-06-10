import React, {PropTypes} from 'react';

export default class RoomView extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    const {node} = this.props;
    return (<div>

      <h1>
          Room population
      </h1>

        {
            node
                ? <div>


                    </div>
                : null
        }

    </div>);
  }
}
