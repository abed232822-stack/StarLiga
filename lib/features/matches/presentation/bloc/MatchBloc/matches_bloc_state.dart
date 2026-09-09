part of 'matches_bloc_bloc.dart';                                                                             
                                                                                                              
sealed class MatchesBlocState extends Equatable {
  final List<MatchModel>? upcomingMatches;
  final List<MatchModel>? pastMatches;                                                                       
  final String? errorMessage;                                                                                 
  final DioException? error;                                                                                  
                                                                                                              
  const MatchesBlocState({                                                                                    
    this.upcomingMatches,                                                                                     
    this.pastMatches,                                                                                         
    this.errorMessage,                                                                                        
    this.error,                                                                                               
  });                                                                                                         
                                                                                                              
  @override                                                                                                   
  List<Object?> get props => [upcomingMatches, pastMatches, errorMessage, error];                             
}                                                                                                             
                                                                                                              
final class MatchesBlocInitial extends MatchesBlocState {}                                                    
                                                                                                              
class MatchesLoadingState extends MatchesBlocState {                                                          
  const MatchesLoadingState();                                                                                
}                                                                                                             
                                                                                                              
class MatchesSuccessState extends MatchesBlocState {                                                          
  const MatchesSuccessState({super.upcomingMatches, super.pastMatches});                                      
}                                                                                                             
                                                                                                              
class MatchesFailedState extends MatchesBlocState {                                                           
  const MatchesFailedState({super.error, super.errorMessage});                                                
}