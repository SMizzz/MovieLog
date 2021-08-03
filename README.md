# MovieLog

앱 소개글

- 기간: 2021. 07 .16 ~ (약 7일간 MVP 완성)
- 소개

    - 영화를 검색하고, 내가 본 영화에 대한 메모를 남길 수 있는 서비스

- 개발 언어

    - Swift

- 프레임워크

    - CoreData

- 사용한 라이브러리

    - Moya
    - SwiftyJSON
    - Kingfisher

- 실행 화면

![스크린샷 2021-08-03 오후 2 03 00](https://user-images.githubusercontent.com/62836016/127969981-f6ae918a-bcb5-4cb0-ab81-367d2cf3ac75.png)

- 기능 정리

    - Home: 최신 영화, 인기 영화, 개봉 영화

    - Search: 영화 검색

    - My: 메모 리스트

- 네트워킹
    - Moya: API 통신

        → 네트워킹을 구현할 때 가장 기본적인 방식 중에 URLSession이나 Alamofire가 있다.

        URLSession을 사용하면 외부 라이브러리를 사용하지 않아도 되는 장점이 있지만, 코드의 가독성이 떨어지고 복잡하다.

        Alamofire도 재사용성과 가독성이 떨어져 이를 보완하기 위해  `Moya`라는 라이브러리가 나왔다. 

        ![스크린샷 2021-08-03 오후 3 21 14](https://user-images.githubusercontent.com/62836016/127969991-ae9674fb-5725-4a76-a597-016f603a55ff.png)

        *Moya 공식 문서 발췌..*

        기존 Alamofire를 직접적으로 네트워킹하려면 Network 파일을 만들어 Alamofire를 호출했는데  
  
        이는 완전히 추상화가 되지 않아 지저분하지만, Alamofire를 추상화한 `Moya`는 템플릿 형태로 되어있어  
          
        재사용성을 높힌다고 한다. 우리는 request와 response만 처리해주면 된다.  

        ```swift
        추상화란?
        객체 지향 프로그래밍의 특징 중 하나로,
        객체들의 공통적인 부분을 뽑아내어 따로 구현해놓은 것을 말한다.
        구체적인 정보를 담아놓은게 아니라 추상적이다라는 표현을 쓴다.
        ```

        따라서 API를 호출할 때 기존 2가지 방식으로도 작성했지만

        재사용성과 가독성을 고려했을 때 좋지 않은 코드가 될 것 같아서 `Moya` 라이브러리를 사용했다.

        Moya 사용 전) URLSession & Alamofire 

        ```swift
        // #1 URLSession networking
          private func configureUrlSession() {
            getData()
          }
          
          private func getData() {
            guard let movieUrl = URL(string: movieUrlString) else { return }
            let request = URLRequest(url: movieUrl)
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
              if error != nil {
                print(error?.localizedDescription)
                return
              }
              
              do {
                let jsonResult = try JSONSerialization.jsonObject(
                    with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                let jsonMovies = jsonResult!["results"] as! [AnyObject]
                
                for movies in jsonMovies {
                  var movie = Movie()
                  movie.thumbNailImage = movies["poster_path"] as! String
                  movie.movieName = movies["original_name"] as! String
                  movie.average = Float(movies["vote_average"] as! NSNumber)
                  movie.overview = movies["overview"] as! String
                  
                  self.movieData.append(movie)
                }
                
                OperationQueue.main.addOperation {
                  self.collectionView.reloadData()
                }
                
              } catch let error {
                print(error.localizedDescription)
              }
            }.resume()
          }

        // #2 Alamofire networking
          private func configureAlamofire() {
            getData()
          }
          
          private func getData() {
            guard let movieUrl = URL(string: movieUrlString) else { return }
            let request = URLRequest(url: movieUrl)
            
            AF.request(request).responseData { (response) in
              switch response.result {
              case .success(let data):
                print(data)
                self.movieData = self.parseJsonData(data: data)
                OperationQueue.main.addOperation {
                  self.collectionView.reloadData()
                }
                break
              case .failure(let error):
                print(error)
                break
              }
            }
          }
          
          func parseJsonData(data: Data) -> [Movie] {
            do {
              let decoder = JSONDecoder()
              let movieDataStore = try decoder.decode(MovieDataStore.self, from: data)
              self.movieData = movieDataStore.results
            } catch let error {
              print(error)
            }
            return movieData
          }
        }
        ```

        Moya 사용 후) 열거형으로 템플릿화된 네트워킹 방식

        ```swift
        import Moya

        enum MovieAPI {
          case nowPlaying
          case topRated
          case upComing
          case popular
          case detail(id: Int)
          case movieSearch(query: String)
        }

        extension MovieAPI: TargetType {
          var baseURL: URL {
            guard let url = URL(string: "https://api.themoviedb.org/3") 
        		else { fatalError("url error") }
            return url
          }
          
          var path: String {
            switch self {
            case .nowPlaying:
              return "/movie/now_playing"
            case .topRated:
              return "/movie/top_rated"
            case .upComing:
              return "/movie/upcoming"
            case .popular:
              return "/movie/popular"
            case .detail(let id):
              return "/movie/\(id)"
            case .movieSearch(_):
              return "/search/movie"
            }
          }
          
          var method: Moya.Method {
            switch self {
            case .nowPlaying, .topRated, .upComing, .popular, .detail(_), .movieSearch(_):
              return .get
            }
          }
          
          var sampleData: Data {
            return Data()
          }
          
          var task: Task {
            switch self {
            case .nowPlaying, .topRated, .upComing, .popular:
              return .requestParameters(
                parameters: [
                  "api_key": "1f2d99c9366d63893dfedd75762e09ba",
                  "language": "ko"],
                encoding: URLEncoding.queryString)
            case .detail(let id):
              return .requestParameters(
                parameters: [
                  "api_key": "1f2d99c9366d63893dfedd75762e09ba",
                  "language": "ko",
                  "id": id],
                encoding: URLEncoding.queryString)
            case .movieSearch(let query):
              return .requestParameters(
                parameters: [
                  "api_key": "1f2d99c9366d63893dfedd75762e09ba",
                  "language": "ko",
                  "query": query],
                encoding: URLEncoding.queryString)
            }
          }
          
          var headers: [String : String]? {
            return ["Content-Type": "application/json"]
          }
        }
        ```

    - 네트워크 매니저

        → 디코딩 작업을 관리하는 네트워크 매니저 class를 만들어 관리해주었다.

        → VC에서 viewDidLoad에서 구현한 MovieNetworkManager의 타입 메소드를 실행한다.

        → 타입 메소드 내부의 provider.request에 필요한 source를 태워 보내게 되고,  
          
        열거형으로 정의해둔  MovieAPI에 가서 필요한 정보들을 담아 요청하게 된다.  

        → 그런 다음에 CollectionView에 delegate, datasource를 호출하면서 cell이 그려질 때  
          
        get한 json 데이터를 swift 데이터로 변환하는  과정을 거친 뒤, movies 정보를 변수에 담아준다.  

        → 이 때 이 작업이 끝나면 `OperationQueue`로 tableView.reloadData를 작업 중간에  
          
        대기열에 요청하여 병렬로 일을 처리하게 해준다. (addOperation 해주면 바로 작업 대기열에 추가해준다.)  

        ```swift
        // viewDidLoad에 구현
        private func getData() {
          MovieNetworkManager.getMovieData(source: .nowPlaying) { (movies) in
            self.nowPlayingData = movies
            OperationQueue.main.addOperation {
        	  self.tableView.reloadData()
        	}
          }
        }
        ```

        ```swift
        import Moya
        import SwiftyJSON

        class MovieNetworkManager {
          static let provider = MoyaProvider<MovieAPI>()
          static func getMovieData(
            source: MovieAPI,
            completion: @escaping([Movie]) -> ()
          ) {
            provider.request(source) { (result) in
              switch result {
              case .success(let res):
                do {
                  let movieData = try JSONDecoder().decode(MovieDataStore.self, from: res.data)
                  completion(movieData.results)
                } catch let err {
                  print(err)
                  print(err.localizedDescription)
                  return
                }
              case .failure(let err):
                print(err.localizedDescription)
                return
              }
            }
          }
          
          static func getDetailMovieData(
            id: Int,
            completion: @escaping(Movie) -> ()
          ) {
            provider.request(.detail(id: id)) { (result) in
              switch result {
              case .success(let res):
                do {
                  let movieData = try JSONDecoder().decode(Movie.self, from: res.data)
                  completion(movieData)
                } catch let err {
                  print(err.localizedDescription)
                  return
                }
              case .failure(let err):
                print(err.localizedDescription)
                return
              }
            }
          }
        }
        ```

- 기억에 남는 오류 해결
- `DecodingError`

    얼마 전까지 잘되던 API 데이터가 로드가 되지 않는 상황이 발생했다.

    그래서 디버깅해보니 에러 메세지가 '디코딩 에러'가 났다고 뜬다.

    `Error while JSON decoding: Swift.DecodingError~~`

    여태까지 문제 없이 디코딩되었던 JSON데이터의 thumbNailImage부분이

    갑자기 에러가 난다니... 조금 이상했지만 연동했던 오픈 API를 다시 살펴보기 시작했다.

    그랬더니 "poster_path" 키 값이 value가 Null인 경우가 생겨났다.

    즉, 영화 썸네일 이미지의 경로에 대한 데이터를 담고있는 value가 Null인 경우가 생겼다.

    ### 그래서 먼저

    디코딩할 때 poster_path값이 Null로 떨어질 수 있다는 것을 명시해주기 위해 옵셔널을 명시해주었다.

    var thumbNailImage: String? = ""

    그런데 계속해서 디코딩 에러가 났고, 이를 핸들링하기 위해 구현해놨던 부분을 살펴보기 시작했는데

    try부분에 do catch 문을 다 적지 않고도 간편히 에러 처리가 가능한 try?나 try!를 사용하는 게 적합하다고 생각했다. 

    try!는 에러 발생 시 충돌이 발생하기 때문에 예외가 생기지 않는 것이 확실할 때 사용해야 한다.

    1) try?는 에러 발생 시 nil을 반환하고, 발생하지 않으면 옵셔널을 반환하기 때문에 thumbNailImage 값이  
      
    nil일 수도 아닐 수도 있는 지금의 경우에서는 try?를 사용하는 게 적합하다고 생각했다.

    따라서 try?로 에러를 온전히 핸들링할 수 있었다.

    ```swift
    thumbNailImage = try values.decode(String.self, forKey: .thumbNailImage)
    ```

    ```swift
    thumbNailImage = try? values.decode(String.self, forKey: .thumbNailImage)
    ```

    이제 옵셔널로 반환되거나 값이 없을 경우를 핸들링 해주기 위해서 

    CollectionView Cell에서 Cell을 그려주는 함수에서 if let으로 옵셔널 바인딩을 해주었고,

    값이 있다면 해당 value값을 이미지로, 값이 없다면 else 구문에서 다른 이미지로 대체하는 것으로 해결해주었다.

    (이미지 값이 nil이라면 해당 정보는 삭제하고 이미지 값이 있는 것만 보여줘도 되겠다.)

    그랬더니 문제없이 데이터를 잘 불러왔다.

    그리고 또 다른 방법은

    2) decodeIfPresent 메소드를 사용하는 것이다.

    공식문서에는 이렇게 설명이 되어있는데 `Decodes a value of the given type for the given key, if present.`  
      
    값이 있는 경우 지정된 키에 대해 지정된 유형의 값을 디코딩하는 거라고 보면 될 것 같다.  
  
    그래서 없을 경우 리턴 값이 궁금했는데 옵셔널을 반환한다.

    ```jsx
    func decodeIfPresent(
    	_ type: Int8.Type,
    	forKey key: KeyedDecodingContainer<K>.Key
    ) throws -> Int8?
    ```

    따라서 decodeIfPresent를 사용하더라도 위에서 if let 을 사용해 nil 값을 관리해줘야 한다.

    그런데 위 방식처럼 사용하게 되면 나중에 값을 if let으로 하나하나 풀어줘야하기 때문에 키는 있는데 value가 있을 수도, 없을 수도 있는 상황에서는 아래처럼 코드를 짜는 것이 깔끔해보인다.

    ```swift
    // #1 try?
    thumbNailImage = (try? values.decode(String.self, forKey: .thumbNailImage)) ?? ""

    // #2 String?
    thumbNailImage = (try values.decode(String?.self, forKey: .thumbNailImage)) ?? ""
    ```

    이번 에러를 해결하면서 느낀 점은 에러를 최대한 발생시키지 않도록 방어적인 코드를 작성해주는 것도 중요하다는 것이었다.  
      
    '무조건 이 부분에서 에러가 날거야 그래서 이 에러가 났을 때는 얼럿을 띄워줘야 해' 이런 에러 핸들링과는 조금 결이 다른 부분을 경험해서 즐거웠다.  
  
    물론 서비스에서 데이터가 로드되지 않다면 결국엔 에러의 문제로 직결되지만 코드를 잘 작성해도 오픈되어 있는 API를 연동할 때는  
      
    nil 값을 받을 수도 있다는 전제를 항상 두고 코드를 구현해야한다는 것을 깨달았다.  
  
- `Unbalanced calls to begin/end appearance transitions for ...`

    Search 탭에서 검색을 하여  Result Search VC → DetailPost VC → Compose VC 로 메모를 작성하고 완료를 누르면  
      
    My VC로 이동해서 내가 작성한 메모를 바로 확인할 수 있게끔 로직을 짰다.  

    `Unbalanced calls to begin/end appearance transitions for ...`

    그러고 Search 탭을 눌렀는데 위와 같은 에러가 떴다. 런타임 에러는 아니라 어떤 에러인 지 조금 더 살펴봤는데  
      
    UI를 관리하는 transition이 끝나지 않은 상태에서 다음 transition을 요청했을 때 발생한다.

    Compose VC에서 작성 완료를 누르면 pop시키고 DetailPost VC에 머무르게 했었는데,

    차라리 유저들이 보기에도 편하게끔 작성 완료를 누르면 아예 PopToRoot를 해주면

    나중에 My VC에서 내가 작성한 메모를 보고 Search탭을 탭하면 트랜지션을 요청했을 때 에러 코드가 나지 않을 줄 알았는데.. 역시나 에러가 났다. 

    그래서 2가지 방법을 생각했는데

    1) 애니메이션을 false 시킨다.

    시간이 오래 걸리는 애니메이션을 하지 않는다.

    혹은 false... 근데 pop이 되지 않거나 그렇게 특별히 오래 걸리는 애니메이션이 없기 때문에 바로 2번 방법으로 생각해봤다. 

    2) Pop되는 속도를 지연시킨다.

    ```swift
    DispatchQueue.main.asyncAfter(deadline: .now()) {
      self.navigationController?.popToRootViewController(animated: true)
    }
    ```

    관리하는 transition이 다 동작하고 난 다음 실행시키는 방법으로 해결했다!
