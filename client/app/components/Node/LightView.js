import React, {PropTypes} from 'react';
import {ResponsiveLine} from '@nivo/line'
import _ from 'lodash'
export default class LightView extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
        lightChartData: null
    }
  }

  componentDidMount() {
      const {node} = this.props;
      console.log(node)
      if (node && !this.state.hourChartData) {
          console.log("hey!!!")
          this.generateLightData(node.als_state)
      }

  }

  componentDidUpdate(prevProps, prevState) {
      if (this.props.node) {
          if (!_.isEqual(prevProps.node, this.props.node)) {
              this.generateLightData(this.props.node.als_state)
          }
      }
  }

  generateLightData(nodeData) {

      console.log(nodeData)

      let steps = nodeData.map((light, index) => {
          return {x: index, y: light}
      })
      // console.log(steps)

      let chartData = {
          data: steps
      }

      this.setState({lightChartData: [chartData]})

  }

  render() {
    const {node} = this.props;

    if (node && !this.state.lightChartData) {
        this.generateLightData(node.als_state)
    }
    return (<div>

      <h1>
          Light
      </h1>

        {
            node && this.state.lightChartData
                ? <div>

                  <div className="charts-container">

                      <div className="chart-title">
                          Light/10 seconds chart</div>
                      <div className="charts">
                          <ResponsiveLine data={this.state.lightChartData} curve="natural" margin={{
                                  "top" : 50,
                                  "right" : 110,
                                  "bottom" : 50,
                                  "left" : 60
                              }} minY="auto" stacked={true} axisBottom={{
                                  "orient" : "bottom",
                                  "tickSize" : 5,
                                  "tickPadding" : 5,
                                  "tickRotation" : 0,
                                  "legend" : "10 seconds",
                                  "legendOffset" : 36,
                                  "legendPosition" : "center"
                              }} axisLeft={{
                                  "orient" : "left",
                                  "tickSize" : 5,
                                  "tickPadding" : 5,
                                  "tickRotation" : 0,
                                  "legend" : "Light intensity",
                                  "legendOffset" : -40,
                                  "legendPosition" : "center"
                              }} dotSize={10} colors="pastel2" dotColor="inherit:darker(0.3)" dotBorderWidth={2} dotBorderColor="#ffffff" enableDotLabel={true} dotLabel="y" dotLabelYOffset={-12} animate={true} motionStiffness={90} motionDamping={15} legends={[{
                                      "anchor": "bottom-right",
                                      "direction": "column",
                                      "translateX": 100,
                                      "itemWidth": 80,
                                      "itemHeight": 20,
                                      "symbolSize": 12,
                                      "symbolShape": "circle"
                                  }
                              ]}/>
                      </div>
                  </div>



                    </div>
                : null
        }

    </div>);
  }
}
