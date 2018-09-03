import React, {PropTypes} from 'react';
import {ResponsiveLine} from '@nivo/line'
import _ from 'lodash'

export default class PressureView extends React.Component {
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
            this.generatePressData(node.data.press)
        }

    }

    componentDidUpdate(prevProps, prevState) {
        if (this.props.node) {
            if (!_.isEqual(prevProps.node, this.props.node)) {
                this.generatePressData(this.props.node.data.press)
            }
        }
    }

    // componentWillReceiveProps(nextProps) {
    //      if (nextProps.node !== this.props.node) {
    //            this.generateTempData(node)
    //      }
    // }

    generatePressData(nodeData) {

        // console.log(nodeData)

        let steps = nodeData.map((press, index) => {
            return {x: index, y: press}
        })
        // console.log(steps)

        let chartData = {
            data: steps
        }

        this.setState({chartData: [chartData]})

    }

    render() {
        const {node} = this.props;
        // console.log(this.state.chartData)

        if (node && !this.state.chartData) {
            this.generatePressData(node.data.temp)
        }

        return (<div>

            <h1>
                Pressure Panel
            </h1>

            {
                node && this.state.chartData
                    ? <div>

                            <div className="charts-container">

                                <div className="chart-title">
                                    Pressure/Time chart</div>
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
                                            "legend" : "pressure",
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
