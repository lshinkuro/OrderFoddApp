//
//  ThreadManager.swift
//  OrderFoodApp
//
//  Created by Phincon on 04/10/24.
//

import Foundation
import UIKit

final class ThreadManager: @unchecked Sendable {
    private var cache: LegacyMutex<[String: Any]> = .init([:])
    private let queue: DispatchQueue = .init(label: "my-queue")
    
    static let shared: ThreadManager = .init()
    
    private init() {}
    
    func setValue(_ value: Any, forKey key: String) {
        cache.withLock{
            $0[key] = value
        }
    }
    
    func getValue<T>(forKey key: String) -> T? {
        cache.withLock{
            $0[key] as? T
        }
    }
}


final class LegacyMutex<Wrapped>: @unchecked Sendable {
    private var mutex = pthread_mutex_t()
    private var wrapped: Wrapped
    
    init(_ initialValue: Wrapped) {
        pthread_mutex_init(&mutex, nil)
        self.wrapped = initialValue
    }
    
    deinit {
        pthread_mutex_destroy(&mutex)
    }
    
    func withLock<R>(_ body: @Sendable (inout Wrapped) throws -> R) rethrows -> R {
        pthread_mutex_lock(&mutex)
        defer { pthread_mutex_unlock(&mutex)}
        return try body(&wrapped)
    }
}

/*
 Kode di atas adalah implementasi thread-safe cache menggunakan mutex (pthread_mutex_t) untuk melindungi akses terhadap data bersama di lingkungan multi-threaded. Mari kita bahas komponen kodenya secara detail:

 1. MARK: ThreadManager Class
 MARK: @unchecked Sendable:
 ThreadManager ditandai sebagai Sendable, yang berarti kelas ini aman untuk digunakan di banyak thread, meskipun ada properti cache yang diakses dari beberapa thread. Kata kunci @unchecked digunakan karena Swift tidak bisa secara otomatis memverifikasi bahwa kelas ini aman untuk digunakan di banyak thread, jadi pengguna memastikan bahwa ini aman secara manual.
 MARK: cache:
 Properti cache adalah instance dari LegacyMutex, yang menyimpan kamus [String: Any]. Mutex digunakan untuk memastikan akses aman ke cache di lingkungan multi-threaded.
 MARK: queue:
 Sebuah DispatchQueue yang digunakan untuk menjalankan operasi secara berurutan. Namun, dalam kode ini queue belum digunakan.
 shared: ThreadManager menggunakan pola singleton. Properti shared memungkinkan instans tunggal ThreadManager diakses dari mana saja.
 setValue(_:forKey:): Metode ini memungkinkan kita untuk menyimpan nilai dalam cache secara aman dengan menggunakan mutex. cache.withLock{} memastikan operasi ini dilakukan di dalam blok yang terlindungi oleh mutex.
 getValue<T>(forKey:): Metode ini memungkinkan kita mendapatkan nilai dari cache secara aman. Jenis yang dikembalikan bersifat generik, jadi penggunaannya fleksibel. Akses ke cache dilindungi dengan mutex untuk memastikan thread safety.
 
 MARK: 2. LegacyMutex<Wrapped> Class
 MARK: @unchecked Sendable:
 Sama seperti ThreadManager, kelas ini diberi atribut Sendable dengan @unchecked karena Swift tidak secara otomatis bisa menjamin thread safety, namun ini diberi kepercayaan bahwa ia aman untuk digunakan di lingkungan multi-threaded.
 MARK: mutex:
 Variabel ini adalah instance dari pthread_mutex_t, yang merupakan primitive synchronization dari POSIX Threads (pthreads). Mutex ini digunakan untuk mengontrol akses ke data yang dilindungi (wrapped).
 MARK: wrapped:
 Properti ini adalah data yang dilindungi oleh mutex. Tipe data ini bersifat generik (Wrapped), sehingga LegacyMutex bisa digunakan untuk melindungi tipe data apa pun.
 init(_ initialValue: Wrapped): Konstruktor menginisialisasi mutex dan menyimpan nilai awal yang dibungkus dalam properti wrapped.
 deinit: Destructor memastikan bahwa mutex dihancurkan ketika instance dari LegacyMutex tidak lagi digunakan, yang penting untuk menghindari kebocoran memori atau resource locking yang tersisa.
 MARK: withLock<R>(_ body:):
 Metode ini memungkinkan kita menjalankan suatu blok kode secara aman di dalam critical section yang dilindungi oleh mutex. Ini adalah metode kunci yang menjamin thread safety dengan mengunci mutex sebelum menjalankan blok kode, kemudian membuka mutex setelahnya (menggunakan defer).
 MARK: Bagaimana Kerja Kode Ini?
 ThreadManager berfungsi sebagai cache thread-safe, di mana kita bisa menyimpan dan mengambil nilai dari cache melalui kunci tertentu.
 LegacyMutex digunakan untuk melindungi data di dalamnya agar hanya satu thread yang dapat mengakses atau memodifikasi data pada satu waktu.
 Saat kita menggunakan setValue(_:forKey:) atau getValue<T>(forKey:) dari ThreadManager, data dalam cache dilindungi oleh mutex yang ada di dalam LegacyMutex, sehingga mencegah kondisi balapan (race conditions) di lingkungan multi-threaded.
 Kesimpulan
 Kode ini adalah contoh sederhana dari thread-safe cache dengan menggunakan mutex untuk melindungi akses ke data. Penggunaan pthread_mutex_t memungkinkan penanganan manual locking dan unlocking resource, sehingga meminimalkan masalah yang terkait dengan akses bersamaan (concurrent access) ke resource yang sama.
 */
