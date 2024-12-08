import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        // 먼저 모델 파일이 있는지 확인
        guard let modelURL = Bundle.main.url(forResource: "AirpodsUsage", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Core Data model not found")
        }
        
        let container = NSPersistentContainer(name: "AirpodsUsage", managedObjectModel: model)
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data store failed to load: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    private init() {
        // 영구 저장소 설정
        let storeDescription = NSPersistentStoreDescription()
        storeDescription.type = NSSQLiteStoreType
        
        // 앱 문서 디렉토리에 데이터베이스 파일 생성
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let url = documentsDirectory.appendingPathComponent("AirpodsUsage.sqlite")
            storeDescription.url = url
        }
        
        persistentContainer.persistentStoreDescriptions = [storeDescription]
    }
    
    func saveUsage(date: Date, duration: TimeInterval) {
        let context = persistentContainer.viewContext
        
        // 같은 날짜의 기존 데이터 확인
        let fetchRequest: NSFetchRequest<UsageEntity> = UsageEntity.fetchRequest()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        
        do {
            let existingEntities = try context.fetch(fetchRequest)
            if let existingEntity = existingEntities.first {
                // 기존 데이터 업데이트
                existingEntity.duration = duration
            } else {
                // 새 데이터 생성
                let entity = UsageEntity(context: context)
                entity.date = date
                entity.duration = duration
            }
            
            try context.save()
        } catch {
            print("Failed to save usage: \(error)")
        }
    }
    
    func getUsage(for date: Date) -> TimeInterval? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UsageEntity> = UsageEntity.fetchRequest()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first?.duration
        } catch {
            print("Failed to fetch usage: \(error)")
            return nil
        }
    }
}
