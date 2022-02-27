import 'dart:io';

import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:painlab_app/model/blocktapping_task.dart';
import 'package:painlab_app/model/multiple_choice_task.dart';
import 'package:painlab_app/model/section.dart';
import 'package:path_provider/path_provider.dart';

class CsvWriter {
  static final Logger logger = Logger();

  static String _writePatientCode(File file, String patientCode) {
    logger.i("CsvWriter | _writePatientCode");
    logger.i("CsvWriter | _writePatientCode | -> 'Patient Code, $patientCode\n'");
    return "Patient Code, $patientCode\n";
  }

  static String _writeDate(File file, String date)  {
    logger.i("CsvWriter | _writeDate");

    logger.i("CsvWriter | _writeDate | -> 'Date/time of Assesment, $date\n'");
    return "Date/time of Assesment, $date\n";
  }

  static String _writeQuestionnaires(File file, Set<Section<MultipleChoiceTask>> questionnaire) {
    logger.i("CsvWriter | _writeQuestionnaires");
    String csv = "\nQuestionnaires,\t\n";
    
    for(Section<MultipleChoiceTask> section in questionnaire) {
      for(MultipleChoiceTask task in section.tasks) {
        logger.i("CsvWriter | _writeQuestionnaires | -> '${task.id}, ${task.result}\n'");
        csv += "${task.id}, ${task.result}\n";
      }
    }

    return csv;
  }

  static String _writeBlocktapping(File file, Set<Section<BlocktappingTask>> blocktapping) {
    logger.i("CsvWriter | _writeBlocktapping");
    String csv = "\nBlock tapping backwards,\t\n";

    int? sum = blocktapping.map((section) {
      return section.tasks.map((task) => task.result ?? 0);
    }).expand((element) => element).reduce((a, b) => a + b);

    csv += "Correct sequences,\t$sum";

    return csv;
  }


  static void export({
    required String patientCode,
    required Set<Section<MultipleChoiceTask>> questionnaire,
    required Set<Section<BlocktappingTask>> blocktapping,
  }) {
    logger.i("CsvWriter | export");
    DateTime now = DateTime.now();
    String date = DateFormat("dd.MM.yyyy/HH:mm").format(now);
    String filenameDate = DateFormat("ddMMyyyy").format(now);

    getApplicationDocumentsDirectory().then((directory) async {
      File file = File("${directory.path}/${patientCode}_$filenameDate.csv");
      if(await file.exists()) {
        logger.i("CsvWriter | export | file ${file.path} exists -> delete");
        await file.delete();
      }

      logger.i("CsvWriter | export | create file ${file.path}");
      await file.create();


      String csv = _writePatientCode(file, patientCode);
      csv += _writeDate(file, date);
      csv += _writeQuestionnaires(file, questionnaire);
      csv += _writeBlocktapping(file, blocktapping);
      await file.writeAsString(csv);
      logger.i("CsvWriter | export | done");
      logger.i(await file.readAsLines());
    });
  }
}