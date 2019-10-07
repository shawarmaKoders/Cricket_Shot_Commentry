#!/usr/bin/env python
# coding: utf-8

import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

from sklearn.metrics import accuracy_score


from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split

from keras import Sequential
from keras.layers import Dense

from sklearn.metrics import confusion_matrix

# get_ipython().run_line_magic('matplotlib', 'inline')


def read_file(filename='finaldata.csv', remove_shot=None):
	dataset = pd.read_csv(filename)
	if remove_shot:
		dataset = dataset[dataset['shotType'] != remove_shot]
	return dataset


def get_scores_df(dataset):
	scores_df = dataset[['score', 'nose.score',
	       'leftEye.score', 'rightEye.score',
	       'leftEar.score',
	       'rightEar.score',
	       'leftShoulder.score',
	       'rightShoulder.score', 'leftElbow.score',
	       'rightElbow.score',
	       'leftWrist.score',
	       'rightWrist.score', 'leftHip.score',
	       'rightHip.score',
	       'leftKnee.score',
	       'rightKnee.score','leftAnkle.score',
	       'rightAnkle.score']]
	return scores_df


def get_coordinates_df(dataset):
	scores_df = get_scores_df(dataset)
	coordinates_df = dataset.drop(list(scores_df.columns), axis=1)
	return coordinates_df


def get_features_and_target(dataset):
	raw_X = dataset.iloc[:, :-1]
	y = dataset.iloc[:,-1]
	return raw_X, y


def perform_preprocessing(raw_X, y):
	y = pd.get_dummies(y,prefix='shotType')
	sc = StandardScaler()
	X = sc.fit_transform(raw_X)
	return X, y


def get_train_and_test_data(X, y, test_size=0.2):
	X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=test_size)
	return X_train, X_test, y_train, y_test


def build_and_return_classifier(X_train, y_train):
	input_dim = X_train.shape[1]
	classifier = Sequential()
	classifier.add(Dense(input_dim//2, activation='relu', kernel_initializer='random_normal', input_dim=input_dim))
	classifier.add(Dense(input_dim//4, activation='relu', kernel_initializer='random_normal', input_dim=input_dim//2))
	classifier.add(Dense(y_train.shape[1], activation='softmax', kernel_initializer='random_normal', input_dim=input_dim//4))
	classifier.compile(optimizer ='adam',loss='binary_crossentropy', metrics =['accuracy'])
	return classifier


def train_classifier(classifier, X_train, y_train, batch_size=10, epochs=100):
	classifier.fit(X_train,y_train, batch_size=batch_size, epochs=epochs)


def get_model_evaluation(classifier, X_train, y_train):
	eval_model = classifier.evaluate(X_train, y_train)
	return eval_model


def get_predictions_on_test_data(classifier, X_test):
	y_pred = classifier.predict(X_test)
	y_pred = (y_pred>0.5)
	return y_pred


def get_confusion_matrix(y_test, y_pred):
	cm = confusion_matrix(y_test.values.argmax(axis=1), y_pred.argmax(axis=1))
	return cm


def main(filename='finaldata.csv', batch_size=10, epochs=100, test_size=0.2):
	dataset = read_file(filename=filename)
	raw_X, y = get_features_and_target(dataset)
	X, y = perform_preprocessing(raw_X, y)
	X_train, X_test, y_train, y_test = get_train_and_test_data(X, y, test_size=test_size)
	classifier = build_and_return_classifier(X_train, y_train)
	train_classifier(classifier, X_train, y_train, batch_size=batch_size, epochs=epochs)

	eval_model = get_model_evaluation(classifier, X_train, y_train)
	y_pred = get_predictions_on_test_data(classifier, X_test)
	cm = get_confusion_matrix(y_test, y_pred)
	print('Accuracy:', accuracy_score(y_test, y_pred))
	print(cm)
	cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
	print(cm)


main(filename='finaldata.csv', batch_size=5, epochs=250, test_size=0.1)