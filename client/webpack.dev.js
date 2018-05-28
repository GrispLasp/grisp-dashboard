const Webpack = require('webpack');
const path = require('path')
const CleanWebpackPlugin = require('clean-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
    context: __dirname,
    entry: [
        'babel-polyfill', 'react-hot-loader/patch', './index.js'
    ],
    node: {
        fs: 'empty'
    },
    output: {
        path: path.resolve(__dirname, 'public/js/'),
        filename: "bundle.js"
    },
    devtool: 'eval',
    resolve: {
        modules: ['node_modules'],
        extensions: ['.js', '.css', '.scss', '.json']
    },

    module: {
        rules: [
            { // css file loader
                test: /\.css$/,
                use: ['style-loader', 'css-loader']
            }, { // js file loader
                test: /\.jsx?$/,
                exclude: /node_modules/,
                loader: 'babel-loader',
                query: {
                    presets: [
                      // "env"
                        "es2015", "react", "stage-1"
                    ],
                    plugins: ['react-hot-loader/babel', "transform-object-assign", "transform-class-properties"]
                }

            }, { // url loader
                test: /\.(png|woff|woff2|eot|ttf|svg)$/,
                loader: 'url-loader?limit=100000'
            }, { // image loader
                test: /\.(jpe*g|png|gif)$/,
                loader: 'file-loader',
                options: {
                    name: '[path][name].[ext]'
                }
            }, {
                test: /\.json$/,
                loader: 'json-loader'
            }, {
                test: /\.scss$/,
                use: [
                    {
                        loader: "style-loader" // creates style nodes from JS strings
                    }, {
                        loader: "css-loader" // translates CSS into CommonJS
                    }, {
                        loader: "sass-loader", // compiles Sass to CSS
                        options: {
                            includePaths: ['./node_modules']
                        }
                    }
                ]
            }
        ]
    },
    devServer: {
        contentBase: path.resolve(__dirname, 'public'),
        hot: true,
        historyApiFallback: true,
        headers: {
            'Access-Control-Allow-Origin': '*'
        }
    },
    plugins: [
        new Webpack.NamedModulesPlugin(),
        new Webpack.HotModuleReplacementPlugin(),
        new CleanWebpackPlugin(['./public/js/']),
        new HtmlWebpackPlugin({template: './public/index.html', filename: 'index.html', inject: 'body'}),
        new ExtractTextPlugin(path.resolve(__dirname, 'public/css/main.css'), {allChunks: true})
    ]
};
