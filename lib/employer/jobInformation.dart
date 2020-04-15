/// Jason deserialization of a job.

class Job {
  final List<JobData> jobData;
  Job({this.jobData});

  factory Job.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    List<JobData> jobList = list.map((i) => JobData.fromJson(i)).toList();

    return Job(jobData: jobList);
  }
}

class JobData {
  final String jobId;
  final String title;
  final String wage;
  final String position;
  final String hours;
  final String location;
  final String description;
  final String datePosted;
  final String expiryDate;
  final String status;
  final String maxCandidate;
  final String companyName;

  JobData(
      {this.jobId,
      this.title,
      this.wage,
      this.position,
      this.hours,
      this.location,
      this.description,
      this.datePosted,
      this.expiryDate,
      this.status,
      this.maxCandidate,
      this.companyName});

  factory JobData.fromJson(Map<String, dynamic> parsedJson) {
    return JobData(
        jobId: parsedJson['job_id'].toString(),
        title: parsedJson['title'].toString(),
        wage: parsedJson['wage'].toString(),
        position: parsedJson['position'].toString(),
        hours: parsedJson['hours'].toString(),
        location: parsedJson['location'].toString(),
        description: parsedJson['description'].toString(),
        datePosted: parsedJson['date_posted'].toString(),
        expiryDate: parsedJson['expiry_date'].toString(),
        status: parsedJson['status'].toString(),
        maxCandidate: parsedJson['max_candidate'].toString(),
        companyName: parsedJson['company_name'].toString());
  }
}
