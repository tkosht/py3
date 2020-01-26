from matplotlib import pyplot
import pandas as pd
from fbprophet import Prophet


if __name__ == "__main__":
    from fbprophet.plot import plot_plotly
    import plotly.offline as py
    # py.init_notebook_mode()

    df = pd.read_csv('data/example_wp_log_peyton_manning.csv')
    m = Prophet()
    m.fit(df)

    future = m.make_future_dataframe(periods=365)
    forecast = m.predict(future)
    fig = plot_plotly(m, forecast)  # This returns a plotly Figure
    py.iplot(fig)
