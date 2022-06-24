import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output, ClientsideFunction

import numpy as np
import pandas as pd
import datetime
from datetime import datetime as dt
import pathlib

import plotly.express as px

app = dash.Dash(
    __name__,
    meta_tags=[{"name": "viewport", "content": "width=device-width, initial-scale=1"}],
)
app.title = "Clinical Analytics Dashboard"

server = app.server
app.config.suppress_callback_exceptions = True

# Path
BASE_PATH = pathlib.Path(__file__).parent.resolve()
DATA_PATH = BASE_PATH.joinpath("3_dashboard_data").resolve()

# Read data
df = pd.read_csv(DATA_PATH.joinpath("main_dataset.csv"))

def plot_map(color_var):
    fig = px.choropleth(df, 
                        geojson=df.geometry,
                        locations=df.index,
                        color=color_var)
    fig.update_geos(fitbounds="locations", visible=False)
    fig.update_layout(
        autosize=True,
        width=1000,
        height=500)
    
    return fig

def intialize_table():
    return 'no table'

default_fig = plot_map('GemiddeldAardgasverbruik')


app.layout = html.Div(
    id="app-container",
    children=[
        # Left column
        html.Div(
            id="left-column",
            className="four columns",
            children=[description_card(), generate_control_card()]
            + [
                html.Div(
                    ["initial child"], id="output-clientside", style={"display": "none"}
                )
            ],
        ),
        # Right column
        html.Div(
            id="right-column",
            className="eight columns",
            children=[
                # Patient Volume Heatmap
                html.Div(
                    id="patient_volume_card",
                    children=[
                        html.B("Patient Volume"),
                        html.Hr(),
                        dcc.Graph(id="patient_volume_hm"),
                    ],
                ),
                # Patient Wait time by Department
                html.Div(
                    id="wait_time_card",
                    children=[
                        html.B("Patient Wait Time and Satisfactory Scores"),
                        html.Hr(),
                        html.Div(id="wait_time_table", children=initialize_table()),
                    ],
                ),
            ],
        ),
    ],
)

# @app.callback(
#     Output("patient_volume_hm", "figure"),
#     [
#         Input("date-picker-select", "color_Var")
#     ],
# )

# def update_heatmap(color_var):
    
#     return plot_map(color_var)
    
# app.clientside_callback(
#     ClientsideFunction(namespace="clientside", function_name="resize"),
#     Output("output-clientside", "children"),
#     [Input("wait_time_table", "children")] + wait_time_inputs + score_inputs,
# )

# Run the server
if __name__ == "__main__":
    app.run_server(debug=True)
