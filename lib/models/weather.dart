import 'dart:convert';

Weather weatherFromJson(String str) => Weather.fromJson(json.decode(str));

String weatherToJson(Weather data) => json.encode(data.toJson());

class Weather {
  final Records? records;

  Weather({
    this.records,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        records: Records.fromJson(json["records"]),
      );

  Map<String, dynamic> toJson() => {
        "records": records?.toJson(),
      };
}

class Records {
  final String datasetDescription;
  final List<Location> location;

  Records({
    required this.datasetDescription,
    required this.location,
  });

  factory Records.fromJson(Map<String, dynamic> json) => Records(
        datasetDescription: json["datasetDescription"],
        location: List<Location>.from(
            json["location"].map((x) => Location.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "datasetDescription": datasetDescription,
        "location": List<dynamic>.from(location.map((x) => x.toJson())),
      };
}

class Location {
  final String locationName;
  final List<WeatherElement> weatherElement;

  Location({
    required this.locationName,
    required this.weatherElement,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        locationName: json["locationName"],
        weatherElement: List<WeatherElement>.from(
            json["weatherElement"].map((x) => WeatherElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "locationName": locationName,
        "weatherElement":
            List<dynamic>.from(weatherElement.map((x) => x.toJson())),
      };
}

class WeatherElement {
  final String elementName;
  final List<Time> time;

  WeatherElement({
    required this.elementName,
    required this.time,
  });

  factory WeatherElement.fromJson(Map<String, dynamic> json) => WeatherElement(
        elementName: json["elementName"],
        time: List<Time>.from(json["time"].map((x) => Time.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "elementName": elementName,
        "time": List<dynamic>.from(time.map((x) => x.toJson())),
      };
}

class Time {
  final String startTime;
  final String endTime;
  final Parameter parameter;

  Time(
      {required this.startTime,
      required this.endTime,
      required this.parameter});

  factory Time.fromJson(Map<String, dynamic> json) => Time(
        startTime: json["startTime"],
        endTime: json["endTime"],
        parameter: Parameter.fromJson(json["parameter"]),
      );

  Map<String, dynamic> toJson() => {
        "startTime": startTime,
        "endTime": endTime,
        "parameter": parameter.toJson(),
      };
}

class Parameter {
  final String parameterName;
  final String? parameterValue;
  final String? parameterUnit;

  Parameter(
      {required this.parameterName, this.parameterValue, this.parameterUnit});

  factory Parameter.fromJson(Map<String, dynamic> json) => Parameter(
        parameterName: json["parameterName"],
        parameterValue: json["parameterValue"],
        parameterUnit: json["parameterUnit"],
      );

  Map<String, dynamic> toJson() => {
        "parameterName": parameterName,
        "parameterValue": parameterValue,
        "parameterUnit": parameterUnit,
      };
}
