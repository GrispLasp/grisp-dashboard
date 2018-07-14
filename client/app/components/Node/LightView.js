import React, {PropTypes} from 'react';
import Plot from 'react-plotly.js';
import _ from 'lodash'

export default class LightView extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
        scatterPlot: null
    }
  }

  componentDidMount() {
      const {node} = this.props;
      console.log(node)
      if (node && !this.state.hourChartData) {
          this.generateScatterPlot(node.als_state)
      }

  }

  componentDidUpdate(prevProps, prevState) {
      if (this.props.node) {
          if (!_.isEqual(prevProps.node, this.props.node)) {
              this.generateScatterPlot(this.props.node.als_state)
          }
      }
  }

  generateScatterPlot = (nodeData) => {

      let trace1 = {
          x: nodeData.data.xs,
          y: nodeData.data.ys,
          type: 'scatter',
          mode: 'markers',
          marker: {color: 'red'},
      };


      var data = [trace1];

      var layout = {
          title: 'Scatter Plot'
      };
      let res = {data: data, layout: layout}

      this.setState({scatterPlot: res})

  }

  render() {
    const {node} = this.props;
    console.log(node)
    if (node && !this.state.scatterPlot) {
        this.generateScatterPlot(node.als_state)
    }
    return (<div>

      <h1>
          Light
      </h1>

        {
            node && this.state.scatterPlot
                ? <div>

                  <div className="charts-container">

                      <div className="charts">
                        <Plot data={this.state.scatterPlot.data}
                           layout={this.state.scatterPlot.layout}/>
                      </div>
                  </div>



                    </div>
                : null
        }

    </div>);
  }
}
