import React, {PropTypes} from 'react';

export default class LightView extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    const {node} = this.props;
    return (<div>

      <h1>
          Light
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
