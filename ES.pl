% Travel Explorer Expert System

% Developed by: [Faisal aljaber(2240004341),Abdullah adel abahussain 2240004126,Abdulaziz Ghassan Bukhamsin
2240002565,ali Ibrahim idhaim 
2240003941]



%  Description:

% This Expert System assists users in finding their ideal travel destination based on their preferences and city qualities.

% Users will be asked about their preferred environment, activity type, budget level, and trip duration.

% Based on their responses and the qualities of cities, the system will suggest the best matching city.
The first step: To use this system, you must first type start in order for the program to start
Step Two: The system will show some questions about the trip you want to take
Step Three: The system will show the best place you can go based on your answers

to Repeat or End the program: You can choose to provide feedback for more suggestions or end the program. The system will continue to suggest cities based on your preferences until you decide to stop.

Explore Fallback Suggestions: If no exact match is found for your preferences, the system will provide fallback suggestions. You can explore these suggestions as well.



% Facts about destinations, cities, and their qualities

% destination(Environment, ActivityType, SpecificActivity, BudgetLevel, TripDuration, City)

destination(beach, relaxing, swimming, low, short, 'Jeddah').

destination(mountains, adventurous, hiking, medium, short, 'Taif').

destination(city, cultural, sightseeing, high, long, 'Riyadh').

destination(jungle, adventurous, wildlife_exploration, medium, long, 'Abha').

destination(beach, adventurous, scuba_diving, high, long, 'Yanbu').

destination(mountains, relaxing, skiing, high, long, 'Al-Baha').

destination(city, cultural, nightlife, medium, short, 'Jeddah').



% Facts about cities and their qualities

% city_quality(City, Quality)

city_quality('Jeddah', 'Beautiful beaches and vibrant nightlife').

city_quality('Taif', 'Scenic mountains and mild climate').

city_quality('Riyadh', 'Rich history, culture, and modern amenities').

city_quality('Abha', 'Lush greenery, cooler climate, and natural beauty').

city_quality('Yanbu', 'Diving spots, marine life, and coastal attractions').

city_quality('Al-Baha', 'Mountainous landscapes, parks, and outdoor activities').



% Dynamic predicate to store user feedback

:- dynamic(user_feedback/2).



% Assign weights to each preference

weight(environment, 0.4).

weight(activity_type, 0.3).

weight(budget_level, 0.2).

weight(trip_duration, 0.1).



% Calculate match percentage for a city

match_percentage(City, Environment, ActivityType, BudgetLevel, TripDuration, Percentage) :-

    findall(Weight, (

        destination(Environment, ActivityType, _, BudgetLevel, TripDuration, City),

        weight(Environment, WeightEnvironment),

        weight(ActivityType, WeightActivityType),

        weight(BudgetLevel, WeightBudgetLevel),

        weight(TripDuration, WeightTripDuration),

        Weight is WeightEnvironment + WeightActivityType + WeightBudgetLevel + WeightTripDuration

    ), Weights),

    sum_list(Weights, Percentage).



% Rule to suggest the best matching city based on user preferences



suggest_best_city(BestCity) :-

    get_user_preferences(Environment, ActivityType, BudgetLevel, TripDuration),

    findall(Percentage-City, (

        match_percentage(City, Environment, ActivityType, BudgetLevel, TripDuration, Percentage)

    ), Percentages),

    (Percentages = [] -> fallback(_) ; max_member(_-BestCity, Percentages)),

    explain_suggestion(BestCity, Environment, ActivityType, BudgetLevel, TripDuration),

    ask_for_feedback(BestCity, 'yes').













 %Rule to explain why a city is suggested



explain_suggestion(BestCity, Environment, ActivityType, BudgetLevel, TripDuration) :-

    city_quality(BestCity, Quality),

    write(BestCity), write(' is suggested because it offers: '), write(Quality), nl,

    write('This matches your preferences for a '), write(Environment), write(' environment, '),

    write(ActivityType), write(' activities, a '), write(BudgetLevel), write(' budget, and a '), 

    write(TripDuration), write(' trip.'), nl.



% Fallback mechanism if no exact match is found



fallback(_) :-

    write('Sorry, we couldn\'t find an exact match for your preferences. Here are some suggestions:'), nl,

    findall(Quality-City, city_quality(City, Quality), Qualities),

    (Qualities = [] -> write('No suggestions available.'), nl ; max_member(_-BestCity, Qualities)),

    explain_suggestion(BestCity, 'unknown', 'unknown', 'unknown', 'unknown').





% Rule to gather user preferences

get_user_preferences(Environment, ActivityType, BudgetLevel, TripDuration) :-

    write('What environment do you prefer? (beach/mountains/city/jungle)'), nl,

    read(Environment),

    write('What type of activity do you enjoy? (relaxing/adventurous/cultural)'), nl,

    read(ActivityType),

    write('What is your budget level? (low/medium/high)'), nl,

    read(BudgetLevel),

    write('How long do you plan your trip to be? (short/long)'), nl,

    read(TripDuration).





% Rule to gather user feedback and learn from it

ask_for_feedback(BestCity, Feedback) :-

    assert(user_feedback(BestCity, Feedback)).





% Rule to learn from user feedback

learn_from_feedback :-

    forall(user_feedback(City, Feedback),

           (update_quality(City, Feedback),

            retract(user_feedback(City, Feedback)))).



% Rule to update city quality based on feedback

update_quality(City, yes) :-

    city_quality(City, Quality),

    atom_concat(Quality, ', Highly recommended by users', NewQuality),

    retract(city_quality(City, Quality)),

    assertz(city_quality(City, NewQuality)).



update_quality(City, no) :-

    city_quality(City, Quality),

    atom_concat(Quality, ', Not recommended by users', NewQuality),

    retract(city_quality(City, Quality)),

    assertz(city_quality(City, NewQuality)).



% Rule to start the Expert System

start :-

    suggest_best_city(_).
