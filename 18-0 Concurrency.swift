//
//  18Concurrency.swift
//  SwiftTutorial
//
//  Created by deerdev on 2023/2/5.
//  Copyright © 2023 deerdev. All rights reserved.
//

import Foundation

/**
 在 Swift 中，一个异步函数可以交出它在某个线程上的运行权，这样另一个异步函数在这个函数被阻塞时就能获得此线程的运行权。但是，Swift并不能确定当异步函数恢复运行时其将在哪条线程上运行。
 */

/// 定义和调用异步函数
// 一种能在运行中被挂起的特殊函数或方法
// async 写在 throws 前面
func listPhotos(inGallery name: String) async throws -> [String] {
    try await Task.sleep(until: .now + .seconds(2), clock: .continuous)  // 省略一些异步网络请求代码
    return ["IMG001", "IMG99", "IMG0404"]
}

func downloadPhoto(named: String) async -> Data {
    return Data()
}

func show(_ name: Data) {
}

func testAsync() async {
    let photoNames = try! await listPhotos(inGallery: "Summer Vacation")
    let sortedNames = photoNames.sorted()
    let name = sortedNames[0]
    let photo = await downloadPhoto(named: name)
    show(photo)
}
/*
 1. 代码从第一行开始执行到第一个 await，调用 listPhotos(inGallery:) 函数并且挂起这段代码的执行，等待这个函数的返回。
 2. 当这段代码的执行被挂起时，程序的其他并行代码会继续执行。比如，后台有一个耗时长的任务更新其他一些图库。那段代码会执行到被 await 的标记的悬点，或者执行完成。
 3. 当 listPhotos(inGallery:) 函数返回之后，上面这段代码会从上次的悬点开始继续执行。它会把函数的返回赋值给 photoNames 变量。
 4. 定义 sortedNames 和 name 的那行代码是普通的同步代码，因为并没有被 await 标记，也不会有任何可能的悬点。
 5. 接下来的 await 标记是在调用 downloadPhoto(named:) 的地方。这里会再次暂停这段代码的执行直到函数返回，从而给了其他并行代码执行的机会。
 6. 在 downloadPhoto(named:) 返回后，它的返回值会被赋值到 photo 变量中，然后被作为参数传递给 show(_:)。
 */

// 代码中被 await 标记的悬点表明当前这段代码可能会暂停等待异步方法或函数的返回。这也被称为让出线程（yielding the thread）
// 因为在幕后 Swift 会挂起你这段代码在当前线程的执行，转而让其他代码在当前线程执行

// 可以通过调用 `Task.yield()` 来显式地插入挂起点
// 在处理耗时任务时，可以插入挂起点来让出线程，从而让其他任务运行(如果一直运行，会阻塞主线程，插入挂起点，让出线程，其他任务运行)
func generateSlideshow(forGallery gallery: String) async {
    let photos = try! await listPhotos(inGallery: gallery)
    for photo in photos {
        // ... 为这张照片渲染一段几秒钟的视频 ...
        await Task.yield()

    }
}

/// 明确地表示这段代码不能加入 await 标记，你可以将这段代码重构为一个同步函数：
// 防止在必须同步的代码中间插入 await 打断同步代码
func move(_ photoName: String, from source: String, to destination: String) {
    //    add(photoName, to: destination)
    //    remove(photoName, from: source)
}

func testAsync2() async {
    let firstPhoto = try! await listPhotos(inGallery: "Summer Vacation")[0]
    /*
    add(firstPhoto, toGallery: "Road Trip")
    //此时，firstPhoto暂时地同时存在于两个画廊中
    remove(firstPhoto, fromGallery: "Summer Vacation")
     */

    // 重构成一个同步函数，无法拆分
    move(firstPhoto, from: "Summer Vacation", to: "Road Trip")
}

/// Result
/// 通过 Result 类型来处理错误,可以使用 Result 来存储这个错误，以便将错误交由其他地方的代码来处理
func listDownloadedPhotos(inGallery: String) throws -> [String] {
    return []
}

func availableRainyWeekendPhotos() -> Result<[String], Error> {
    return Result {
        try listDownloadedPhotos(inGallery: "A Rainy Weekend")
    }
}

/// 异步序列 AsyncSequence
/// 想让自己创建的类型使用 for-in 循环需要遵循 Sequence 协议，
/// 这里也同理，如果想让自己创建的类型使用 for-await-in 循环，就需要遵循 `AsyncSequence` 协议。
/// 在这里 await 也标注了潜在的挂起点。一个 for-await-in 循环在每一轮迭代的开头都有可能挂起，以便等待序列中下一个元素的就绪
func testAsyncQue() async throws {
    let handle = FileHandle.standardInput
    for try await line in handle.bytes.lines {
        print(line)
    }
}

/// 并行的调用异步方法
/// 短时间内不需要异步函数的返回结果时，使用 async-let 来调用函数。这样任务就可以并行执行。
func parallelCallingAsyncTask() async {
    let photoNames = ["IMG001", "IMG99", "IMG0404"]
    // 三次调用 downloadPhoto(named:) 都不需要等待前一次调用结束。如果系统有足够的资源，这三次调用甚至都可以同时执行。
    async let firstPhoto = downloadPhoto(named: photoNames[0])
    async let secondPhoto = downloadPhoto(named: photoNames[1])
    async let thirdPhoto = downloadPhoto(named: photoNames[2])

    let photos = await [firstPhoto, secondPhoto, thirdPhoto]
    //    show(photos)
}

/// 任务和任务组
// *任务（task)*是一项工作，可以作为程序的一部分并发执行。所有的异步代码都属于某个任务。
// async-let 语法就会产生一个子任务
//可以创建一个任务组并且给其中添加子任务，这可以让你对优先级和任务取消有了更多的掌控力，并且可以控制任务的数量。
func add(_ photo: String, toGalleryNamed name: String) async {}
func testGroupTask() async {

    /// 结构化并发（structured concurrency）- 有父任务
    // 任务是按层级结构排列的。同一个任务组中的任务拥有相同的父任务，并且每个任务都可以添加子任务。由于任务和任务组之间明确的关系，这种方式又被称为结构化并发（structured concurrency）
    // 如果代码可能抛出错误，你需要调用 withThrowingTaskGroup(of:returning:body:)。
    let results = await withTaskGroup(of: Data.self) { taskGroup in
        let photoNames = try! await listPhotos(inGallery: "Summer Vacation")
        for name in photoNames {
            taskGroup.addTask { await downloadPhoto(named: name) }
        }
        var results: [Data] = []
        for await photo in group {
            results.append(photo)
        }
        return results

        // 无返回值
        // for await photo in taskGroup {
        //     show(photo)
        // }
    }

    /// 非结构化任务（unstructured task）
    // Swift 还支持非结构化并发。与任务组中的任务不同的是，非结构化任务（unstructured task）并没有父任务
    // 你能以任何方式来处理非结构化任务以满足你程序的需要，但与此同时，你需要对于他们的正确性付全责。
    // 如果想创建一个在当前 actor 上运行的非结构化任务，需要调用构造器 Task.init(priority:operation:)。
    // 如果想要创建一个不在当前 actor 上运行的非结构化任务（更具体地说就是游离任务（detached task）），需要调用类方法 Task.detached(priority:operation:)。
    // 以上两种方法都能返回一个能让你与任务交互（继续等待结果或取消任务）的任务句柄，如下：
    let newPhoto = ""  // ... 图片数据 ...
    let handle = Task {
        return await add(newPhoto, toGalleryNamed: "Spring Adventures")
    }
    let result = await handle.value
}

/// 任务取消
/// Swift 中的并发使用合作取消模型。每个任务都会在执行中合适的时间点检查自己是否被取消了，并且会用任何合适的方式来响应取消操作。这些方式会根据你所执行的工作分为以下几种：
/// - 抛出如 CancellationError 这样的错误
/// - 返回 nil 或者空的集合
/// - 返回完成一半的工作
///
/// 如果想检查任务是否被取消，既可以使用 Task.checkCancellation()（如果任务取消会返回 CancellationError），也可以使用 Task.isCancelled 来判断，继而在代码中对取消进行相应的处理。比如，一个从图库中下载图片的任务需要删除下载到一半的文件并且关闭连接。
/// 如果想手动执行扩散取消，调用 Task.cancel()。
let photos = await withTaskGroup(of: Optional<Data>.self) { group in
    let photoNames = await listPhotos(inGallery: "Summer Vacation")
    for name in photoNames {
        let added = group.addTaskUnlessCancelled {
            guard !Task.isCancelled else { return nil }
            return await downloadPhoto(named: name)
        }
        guard added else { break }
    }

    var results: [Data] = []
    for await photo in group {
        if let photo { results.append(photo) }
    }
    return results
}
/**
- 每项任务都使用 TaskGroup.addTaskUnlessCancelled(priority:operation:) 方法来添加, 以避免在任务取消之后产生新的任务。
- 在每次调用 addTaskUnlessCancelled(priority:operation:) 之后, 这段代码都会确认子任务的确已经添加成功了。如果任务组已被取消，那么 added 的值就会为 false —— 这种情况下，代码会不再尝试下载更多的照片。
- 每项任务都会在开始下载照片前，检查取消指令。如果发现任务已被取消，那么返回 nil。
- 最后，任务组在收集结果时会跳过所有的 nil。通过返回 nil 来响应取消指令意味着任务组可以返回部分结果（也就是在取消的那一刻之前已经下载完成的照片），而不是将已完成的工作也一并丢弃。
*/

// 如果你的事务需要在被取消时立即收到提醒，可以使用 Task.withTaskCancellationHandler(operation:onCancel:isolation:) 方法。例如：
let task = await Task.withTaskCancellationHandler {
    // ...
} onCancel: {
    print("Canceled!")
}
// ... 一段时间之后 ...
task.cancel()  // 输出 "Canceled!"

/// Actors: 共享变量
// 你可以使用任务来将自己的程序分割为孤立、并发的部分。
// 任务间相互孤立，这也使得它们能够安全地同时运行。但有时你需要在任务间共享信息。
// Actors便能够帮助你安全地在并发代码间分享信息。
// actor 也是一个引用类型，不同于类的是，actor 在同一时间只允许一个任务访问它的可变状态，这使得多个任务中的代码与一个 actor 交互时更加安全。比如，下面是一个记录温度的 actor：
// Task: https://developer.apple.com/documentation/swift/task
actor TemperatureLogger {
    let label: String
    var measurements: [Int]
    private(set) var max: Int

    init(label: String, measurement: Int) {
        self.label = label
        self.measurements = [measurement]
        self.max = measurement
    }
}

func testActor() async {
    let logger = TemperatureLogger(label: "Outdoors", measurement: 25)
    // 当你访问 actor 中的属性或方法时，需要使用 await 来标记潜在的挂起点，比如：
    // 访问 logger.max 是一个可能的挂起点。因为 actor 在同一时间只允许一个任务访问它的可变状态，如果别的任务正在与 logger 交互，上面这段代码将会在等待访问属性的时候被挂起。
    print(await logger.max)  // 输出 "25"

    // 不加 await 访问 logger.max 会失败,编译器报错
}

// actor 内部的代码在访问其属性的时候不需要添加 await 关键字
// Swift 可以保证只有 actor 内部的代码可以访问 actor 的内部状态。这个保证也被称为 actor isolation。
extension TemperatureLogger {
    func update(with measurement: Int) {
        measurements.append(measurement)
        if measurement > max {
            max = measurement
        }
    }
}
/*
 在这种情况下，其他的代码读取到了错误的值，因为 actor 的读取操作被夹在 update(with:) 方法中间，而此时数据暂时是无效的。你可以用 Swift 中的 actor 以防止这种问题的发生，因为 actor 在同一时刻只允许有一个任务能访问它的状态，而且只有在被 await 标记为悬点的地方代码才会被打断。因为 update(with:) 方法没有任何悬点，没有其他任何代码可以在更新的过程中访问到数据。

Swift 并发模型的以下几个特点共同降低了使用者对共享可变属性的理解成本：
    - 挂起点之间的代码总是按顺序执行，且不可能被任何其它并发代码打断。
    - 与一个 actor 本地状态交互的代码只会运行在这个 actor 之上。
    - 一个 actor 一次只运行一段代码。
基于这些保证，处于一个 actor 之内、且不包含 await 的方法(同步方法，不包含任何挂起点)可以安全地对 actor 状态进行更新，而不用担心程序中的其它部分意外读取到不合法状态。
 */

/// 可发送类型：可作为Actor方法的参数传递
// 任务和Actor能够帮助你将程序分割为能够安全地并发运行的小块。
// 在一个任务中，或是在一个Actor实例中，程序包含可变状态的部分（如变量和属性）被称为并发域（Concurrency domain）。
// 部分类型的数据不能在并发域间共享，因为它们包含了可变状态，但它不能阻止重叠访问。

/**
 * 你可以通过声明其符合 Sendable 协议来将某个类型标记为可发送类型。
 该协议并不包含任何代码要求，但Swift对其做出了强制的语义要求。总之，有三种方法将一个类型声明为可发送类型：

 - 该类型为值类型，且其可变状态由其它可发送数据构成——例如具有存储属性的结构体或是具有关联值的枚举。
 - 该类型不包含任何可变状态，且其不可变状态由其它可发送数据构成——例如只包含只读属性的结构体或类
 - 该类型包含能确保其可变状态安全的代码——例如标记了 @MainActor 的类或序列化了对特定线程/队列上其属性的访问的类。

 https://developer.apple.com/documentation/swift/sendable
 */

// 由于 TemperatureReading 是只有可发送属性的结构体，且该结构体并未被标记为 public 或 @usableFromInline，因此它是隐式可发送的。
struct TemperatureReading: Sendable {
    var measurement: Int
}
extension TemperatureLogger {
    func addReading(from reading: TemperatureReading) {
        measurements.append(reading.measurement)
    }
}

func testSendable() async {
    let logger = TemperatureLogger(label: "Tea kettle", measurement: 85)
    let reading = TemperatureReading(measurement: 45)
    await logger.addReading(from: reading)
}

// 显式声明一个类型为不可发送类型
// FileDescriptor 隐式遵循 Sendable 协议
struct FileDescriptor {
    let rawValue: Int
}

// 显式声明一个类型为不可发送类型
@available(*, unavailable)
extension FileDescriptor: Sendable {}
