class Exercise {
  final String name;
  final int sets;
  final String reps;
  const Exercise(this.name, {this.sets = 3, this.reps = '10-12'});
}

class WorkoutDay {
  final String name;
  final List<Exercise> exercises;
  const WorkoutDay(this.name, this.exercises);
}

final workouts = [
  WorkoutDay('Push', [
    const Exercise('Bench Press', sets: 4, reps: '8-12'),
    const Exercise('Overhead Press', sets: 3, reps: '8-12'),
    const Exercise('Incline Dumbbell Press', sets: 3, reps: '10-12'),
    const Exercise('Lateral Raises', sets: 3, reps: '12-15'),
    const Exercise('Tricep Pushdowns', sets: 3, reps: '12-15'),
  ]),
  WorkoutDay('Pull', [
    const Exercise('Deadlifts', sets: 4, reps: '6-8'),
    const Exercise('Pull-Ups', sets: 3, reps: '8-12'),
    const Exercise('Barbell Rows', sets: 3, reps: '8-12'),
    const Exercise('Face Pulls', sets: 3, reps: '12-15'),
    const Exercise('Bicep Curls', sets: 3, reps: '10-12'),
  ]),
  WorkoutDay('Legs', [
    const Exercise('Squats', sets: 4, reps: '8-10'),
    const Exercise('Romanian Deadlifts', sets: 3, reps: '10-12'),
    const Exercise('Leg Press', sets: 3, reps: '10-12'),
    const Exercise('Walking Lunges', sets: 3, reps: '12'),
    const Exercise('Calf Raises', sets: 4, reps: '15-20'),
  ]),
  WorkoutDay('Core', [
    const Exercise('Plank', sets: 3, reps: '45-60s'),
    const Exercise('Hanging Leg Raises', sets: 3, reps: '12-15'),
    const Exercise('Russian Twists', sets: 3, reps: '15'),
    const Exercise('Cable Crunch', sets: 3, reps: '12-15'),
  ]),
  WorkoutDay('Cardio', [
    const Exercise('Running', sets: 1, reps: '20 min'),
    const Exercise('Jump Rope', sets: 3, reps: '3 min'),
    const Exercise('Burpees', sets: 3, reps: '15'),
    const Exercise('Rowing Machine', sets: 1, reps: '15 min'),
  ]),
];
