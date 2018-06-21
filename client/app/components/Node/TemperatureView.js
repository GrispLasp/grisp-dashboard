import React, {PropTypes} from 'react';
import {ResponsiveLine} from '@nivo/line'
import _ from 'lodash'

export default class TemperatureView extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            hourChartData: null
        }
    }

    componentDidMount() {
        const {node} = this.props;
        console.log(node)
        if (node && !this.state.hourChartData) {
            console.log("hey!!!")
            this.generateTempData(node.temps_state)
        }

    }

    componentDidUpdate(prevProps, prevState) {
        if (this.props.node) {
            if (!_.isEqual(prevProps.node, this.props.node)) {
                this.generateTempData(this.props.node.temps_state)
            }
        }
    }

    // componentWillReceiveProps(nextProps) {
    //      if (nextProps.node !== this.props.node) {
    //            this.generateTempData(node)
    //      }
    // }

    generateTempData(nodeData) {

        console.log(nodeData)

        let steps = nodeData.hour_data.map((hourTemp, index) => {
            return {x: index, y: hourTemp}
        })
        // console.log(steps)

        let chartData = {
            data: steps
        }

        this.setState({hourChartData: [chartData]})

    }

    render() {
        const {node} = this.props;
        console.log("NODEE!!!!!")
        console.log(node)
        console.log(this.state.hourChartData)

        if (node && !this.state.hourChartData) {
            this.generateTempData(node.temps_state)
        }

        return (<div>

            <h1>
                Temperature Panel
            </h1>

            {
                node && this.state.hourChartData
                    ? <div>

                            <p>Average temperature :
                                <b>{node.temps_state.avg.toFixed(2)}
                                    °C</b>
                            </p>
                            <p>Hours passed:
                                <b>{node.temps_state.counter}h</b>
                            </p>

                            <div className="charts-container">

                                <div className="chart-title">
                                    Temperature/hour chart</div>
                                <div className="charts">
                                    <ResponsiveLine data={this.state.hourChartData} curve="natural" margin={{
                                            "top" : 50,
                                            "right" : 110,
                                            "bottom" : 50,
                                            "left" : 60
                                        }} minY="auto" stacked={true} axisBottom={{
                                            "orient" : "bottom",
                                            "tickSize" : 5,
                                            "tickPadding" : 5,
                                            "tickRotation" : 0,
                                            "legend" : "hour",
                                            "legendOffset" : 36,
                                            "legendPosition" : "center"
                                        }} axisLeft={{
                                            "orient" : "left",
                                            "tickSize" : 5,
                                            "tickPadding" : 5,
                                            "tickRotation" : 0,
                                            "legend" : "temperature",
                                            "legendOffset" : -40,
                                            "legendPosition" : "center"
                                        }} dotSize={10} colors="pastel1" dotColor="inherit:darker(0.3)" dotBorderWidth={2} dotBorderColor="#ffffff" enableDotLabel={true} dotLabel="y" dotLabelYOffset={-12} animate={true} motionStiffness={90} motionDamping={15} legends={[{
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
