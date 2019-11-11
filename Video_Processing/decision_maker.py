from pandas import read_csv, DataFrame

if __name__ == '__main__':
    classification_file = read_csv('classification_csvs/pull_1.csv')

    classification_file_attrs = classification_file.describe().iloc[1:, :]

    file_name = 'ot_metrics.csv'
    classification_file_attrs.to_csv(f'metrics/{file_name}')

    classification_means = classification_file_attrs.iloc[0, :]
    classification_stds = classification_file_attrs.iloc[1, :]
    classification_mins = classification_file_attrs.iloc[2, :]
    classification_fifs = classification_file_attrs.iloc[4, :]
    classification_maxs = classification_file_attrs.iloc[6, :]
