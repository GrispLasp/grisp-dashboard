import React, {PropTypes} from 'react';
import {ResponsiveLine} from '@nivo/line'
import _ from 'lodash'

export default class GyroView extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
        chartData: null
    }
  }

  componentDidMount() {
      const {node} = this.props;
      console.log(node)
      if (node && !this.state.chartData) {
          this.generateGyroData(node.data.gyro)
      }

  }

  componentDidUpdate(prevProps, prevState) {
      if (this.props.node) {
          if (!_.isEqual(prevProps.node, this.props.node)) {
              this.generateGyroData(this.props.node.data.gyro)
          }
      }
  }

  generateGyroData(nodeData) {

      console.log(nodeData)

      let xData = nodeData.map((gyro, index) => {
          return {x: index, y: gyro[0]}
      })
      let x = {
        "id": "x",
        "color": "hsl(59, 70%, 50%)",
        "data": xData
      }

      let yData = nodeData.map((gyro, index) => {
          return {x: index, y: gyro[1]}
      })
      let y = {
        "id": "y",
        "color": "hsl(227, 70%, 50%)",
        "data": yData
      }

      let zData = nodeData.map((gyro, index) => {
          return {x: index, y: gyro[2]}
      })
      let z = {
        "id": "z",
        "color": "hsl(268, 70%, 50%)",
        "data": zData
      }

      let data = [
        x,
        y,
        z
      ]



      this.setState({chartData: data})

  }

  render() {
    const {node} = this.props;

    if (node && !this.state.chartData) {
        this.generateGyroData(node.data.gyro)
    }
    return (<div>

      <h1>
          Gyro Panel
      </h1>

        {
            node && this.state.chartData
                ? <div>

                  <div className="charts-container">

                      <div className="chart-title">
                          Gyro/Time chart</div>
                      <div className="charts">
                          <ResponsiveLine data={this.state.chartData} curve="natural" margin={{
                                  "top" : 50,
                                  "right" : 110,
                                  "bottom" : 50,
                                  "left" : 60
                              }} minY="auto" stacked={true} axisBottom={{
                                  "orient" : "bottom",
                                  "tickSize" : 5,
                                  "tickPadding" : 5,
                                  "tickRotation" : 0,
                                  "legend" : "time",
                                  "legendOffset" : 36,
                                  "legendPosition" : "center"
                              }} axisLeft={{
                                  "orient" : "left",
                                  "tickSize" : 5,
                                  "tickPadding" : 5,
                                  "tickRotation" : 0,
                                  "legend" : "Gyro",
                                  "legendOffset" : -40,
                                  "legendPosition" : "center"
                              }} dotSize={10} colors="set3" dotColor="inherit:darker(0.3)" dotBorderWidth={2} dotBorderColor="#ffffff" enableDotLabel={true} dotLabel="y" dotLabelYOffset={-12} animate={true} motionStiffness={90} motionDamping={15} legends={[{
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
