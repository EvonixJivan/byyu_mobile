class EventsList {
  String? status;
  String? message;
  List<EventsData>? eventsData;

  EventsList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      eventsData = <EventsData>[];
      json['data'].forEach((v) {
        eventsData!.add(new EventsData.fromJson(v));
      });
    }
  }
}

class EventsData {
  int? id;
  String? eventName;
  String? eventDescription;
  String? eventImage;
  String? colorcode;
  bool? showData = false;
  String? addedBy;
  String? addedOn;

  EventsData(
      {this.id,
      this.eventName,
      this.eventDescription,
      this.eventImage,
      this.colorcode,
      this.addedBy,
      this.addedOn});

  EventsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventName = json['event_name'];
    eventDescription = json['event_description'];
    eventImage = json['event_image'];
    colorcode = json['colorcode'];
    addedBy = json['added_by'];
    addedOn = json['added_on'];
  }
}

class CelebrationEvents {
  String? status;
  String? message;
  List<Celbrations>? celebrationsList;

  CelebrationEvents.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      celebrationsList = <Celbrations>[];
      json['data'].forEach((v) {
        celebrationsList!.add(new Celbrations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.celebrationsList != null) {
      data['data'] = this.celebrationsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Celbrations {
  String? celebrationName;
  Celbrations({this.celebrationName});

  Celbrations.fromJson(Map<String, dynamic> json) {
    celebrationName = json['celebration_name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['celebration_name'] = this.celebrationName;
    return data;
  }
}

class AddMember {
  String? status;
  String? message;
  List<AddMemberList>? addMemberList;

  AddMember({this.status, this.message, this.addMemberList});

  AddMember.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      addMemberList = <AddMemberList>[];
      json['data'].forEach((v) {
        addMemberList!.add(new AddMemberList.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.addMemberList != null) {
      data['data'] = this.addMemberList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddMemberList {
  int? id;
  String? userId;
  String? name;
  String? relation;
  String? celebrationName;
  String? dateMonth;
  int? monthValue = null;
  String? dateDay;
  // String? dateYear;
  String? addedOn;
  int? isDelete;

  String? icon;
  String? nextdays;

  String eventImage = "";

  AddMemberList(
      {this.id,
      this.userId,
      this.name,
      this.relation,
      this.celebrationName,
      this.dateMonth,
      this.dateDay,
      // this.dateYear,
      this.addedOn,
      this.icon,
      this.nextdays,
      this.isDelete});

  AddMemberList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    relation = json['relation'];
    celebrationName = json['celebration_name'];
    dateMonth = json['date_month'];
    dateDay = json['date_day'];
    // dateYear = json['date_year'];
    addedOn = json['added_on'];

    icon = json['icon'];
    nextdays = json['nextdays'];

    isDelete = json['is_delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['relation'] = this.relation;
    data['celebration_name'] = this.celebrationName;
    data['date_month'] = this.dateMonth;
    data['date_day'] = this.dateDay;
    // data['date_year'] = this.dateYear;
    data['added_on'] = this.addedOn;

    data['icon'] = this.icon;
    data['nextdays'] = this.nextdays;

    data['is_delete'] = this.isDelete;
    return data;
  }
}
