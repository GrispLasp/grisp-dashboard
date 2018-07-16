import React, {PropTypes} from 'react';
import Plot from 'react-plotly.js';
import _ from 'lodash'
import {connect} from 'react-redux'

class NodesView extends React.Component {
  constructor(props) {
    super(props);
    console.log(props)
    this.state = {
        scatterPlot: null,
        linearRegressionPlot: null
    }
  }

  componentDidMount() {
  }

  componentWillReceiveProps(nextProps){

    if(this.props.nodes !== nextProps.nodes){
      this.generatePlots(nextProps.nodes)
    }
  }

  generatePlots = (nodesData) => {

      let data1 = this.generateScatterPlot(nodesData)
      let data2 = this.generateLinearRegression(nodesData)

      this.setState({scatterPlot: data1, linearRegressionPlot: data2})
  }

  generateScatterPlot = (nodesData) => {

      let colors = ['rgb(215,48,39)','rgb(69,117,180)']

      let data = nodesData.map((node, index) => {
        return {
            x: node.als_state.data.xs,
            y: node.als_state.data.ys,
            type: 'scatter',
            mode: 'markers',
            name: node.name,
            marker: {color: colors[index]},
        };
      });

      let layout = {
          title: 'Nodes ambient light scatter plot'
      };
      let res = {data: data, layout: layout}
      return res;

  }

  generateLinearRegression = (nodesData) => {
    let colors = ['rgb(215,48,39)','rgb(69,117,180)']

    let data = nodesData.map((node, index) => {
      let xData = _.range(node.als_state.predictions.length)
      return {
          x: xData,
          y: node.als_state.predictions,
          type: 'scatter',
          name: node.name,
          marker: {color: colors[index]},
      };
    });

    let layout = {
        title: 'Nodes ambient light linear regression'
    };
    let res = {data: data, layout: layout}
    return res;
  }

  render() {
    const {nodes} = this.props;

    return (<div id="main">

               <div className="main-container">

      <h1>
          Ambient light Regression
      </h1>

        {
            nodes && this.state.scatterPlot && this.state.linearRegressionPlot
                ? <div>

                  <div className="charts-container">

                      <div className="charts">
                        <Plot data={this.state.scatterPlot.data}
                           layout={this.state.scatterPlot.layout}/>

                           <Plot data={this.state.linearRegressionPlot.data}
                              layout={this.state.linearRegressionPlot.layout}/>
                      </div>
                  </div>



                    </div>
                : null
        }

    </div>
  </div>);
  }
}

const mapStateToProps = (state, ownProps) => {
    // console.log(state);
    const {nodesReq, isFetching} = state.nodesReducer
    return {nodes: nodesReq.nodes, lastPingTime: nodesReq.lastPingTime}
}

const NodesContainer = connect(mapStateToProps)(NodesView)

export default NodesContainer
