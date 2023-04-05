// kelas elemen dari listnya, berisikan bobot dan value dari elemen tersebut. Dari bobot dan value tersebut kemudian bisa didapat rasionya yang berupa nilai/bobot
class Elemen {
    // bobot
    var bobot: Float

    // value
    var nilai: Float

    // rasio nilai/bobot
    var rasio: Float

    // constructor dari Elemen (atau bisa juga dibilang barang)
    init(bobot: Float, nilai: Float) {
        self.bobot = bobot
        self.nilai = nilai
        
        // rasio akan bernilai sama dengan nilai jika bobot == 0
        if bobot == 0 {
            self.rasio = nilai
        } else {
            self.rasio = nilai/bobot
        }
    }
}

// kelas KnapsackProblem, berisikan daftar barang yang tersedia, barang yang diambil serta kapasitas knapsacknya
class KnapsackProblem {
    // kapasitas
    var kapasitas: Float

    // daftar barang yang tersedia
    var daftarBarang = [Elemen]()

    // daftar barang yang diambil
    var barangJarahan = [Elemen]()

    init() {
        // memasukkan barang-barangnya
        print("Note: perhatikan, kelebihan spasi dapat membuat programnya tidak bisa berjalan")
        print("Masukkan kapasitas knapsack: ", terminator : "")
        let kapasitasKnapsack = Float(readLine()!)!
        print("Masukkan jumlah barang: ", terminator : "")
        let jumlahBarang = Int(readLine()!)!

        self.kapasitas = kapasitasKnapsack

        var temporaryStorage = [Elemen]()
        
        // jika jumlah barang yang tersedia berjumlah lebih dari 0 maka minta input dari pengguna
        if (jumlahBarang > 0) {
            // masukkan terlebih dahulu barang-barang tersebut ke dalam temporary storage sebelum akhirnya dimasukkan ke daftarBarang
            for ctr in 0...jumlahBarang-1 {
                print("Masukkan bobot barang \(ctr+1): ", terminator : "")
                let bobotBarang = Float(readLine()!)!
                print("Masukkan nilai barang \(ctr+1): ", terminator : "")
                let nilaiBarang = Float(readLine()!)!
                temporaryStorage.append(Elemen(bobot: bobotBarang, nilai: nilaiBarang))
            }

            // sort terlebih dahulu semua barang berdasarkan rasionya, kali ini dengan menggunakan insertion sort
            for elemen in temporaryStorage {
                if self.daftarBarang.count == 0 {
                    self.daftarBarang.append(elemen)
                } else {
                    var idx = 0
                    while idx < self.daftarBarang.count && self.daftarBarang[idx].rasio > elemen.rasio {
                        idx += 1
                    }

                    // masukkan di index tersebut
                    self.daftarBarang.insert(elemen, at:idx)
                }
            }
        }
    }

    // prosedur untuk mengambil barang dari daftar barang yang tersedia
    func ambilBarang(x: Int) {
        self.barangJarahan.append(Elemen(bobot: self.daftarBarang[x].bobot, nilai: self.daftarBarang[x].nilai))
        self.kapasitas -= self.daftarBarang[x].bobot
        self.daftarBarang.remove(at: x)
    }

    // prosedur untuk mengeluarkan barang yang tidak sesuai dengan kriteria dari daftar barang yang tersedia
    func hapusBarang(x: Int) {
        self.daftarBarang.remove(at: x)
    }

    // prosedur untuk menampilkan daftar barang yang tersedia 
    func printDaftarBarang() {
        print("Daftar barang: ")
        if (self.daftarBarang.count == 0) {
            print("    Tidak ada barang yang tersedia")
        } else {
            var ctr : Int
            ctr = 0
            for elemen in self.daftarBarang {
                ctr += 1
                print("    Barang no. \(ctr): ")
                print("        bobot: \(elemen.bobot)", terminator : "")
                print("        nilai: \(elemen.nilai)", terminator : "")
                print("        rasio: \(elemen.rasio)")
            }
        }
        print("")
    }

    // prosedur untuk menampilkan daftar barang yang telah diambil
    func printDaftarBarangJarahan() {
        print("Daftar barang jarahan: ")
        if (self.barangJarahan.count == 0) {
            print("    Tidak ada barang yang diambil")
        } else {
            var ctr : Int
            ctr = 0
            var sum : Float
            sum = 0
            for elemen in self.barangJarahan {
                ctr += 1
                sum += elemen.nilai
                print("    Barang no. \(ctr): ")
                print("        bobot: \(elemen.bobot)", terminator : "")
                print("        nilai: \(elemen.nilai)", terminator : "")
                print("        rasio: \(elemen.rasio)")
            }
            print("Nilai total yang didapat: \(sum)")
        }
        print("")
    }

    // fungsi untuk mengecek apakah masih ada barang yang belum dicoba di daftar barang
    func stillAvailable() -> Bool {
        if self.daftarBarang.count <= 1 {
            return false
        }

        return true
    }

    // fungsi untuk mencari barang apa saja yang harus diambil
    func findSolution() {
        self.printDaftarBarang() // tampilkan terlebih dahulu 
    
        while (self.stillAvailable()) { 
            for idx in 0...self.daftarBarang.count-1 {
                // pengaplikasian branch and boundnya disini, kita akan mengecek apakah jika kita memasukkan barang tersebut ke dalam jarahan maka kita akan diuntungkan atau tidak
                var upperBoundDengan: Float
                upperBoundDengan = self.daftarBarang[idx].nilai + ((self.kapasitas-self.daftarBarang[idx].bobot) * (self.daftarBarang[idx+1].nilai/self.daftarBarang[idx+1].bobot))
                var upperBoundTanpa: Float
                upperBoundTanpa = 0 + ((self.kapasitas-0) * (self.daftarBarang[idx+1].nilai/self.daftarBarang[idx+1].bobot))

                if (upperBoundDengan >= upperBoundTanpa && self.kapasitas-self.daftarBarang[idx].bobot >= 0) {
                    ambilBarang(x: idx)
                    break
                } else {
                    hapusBarang(x: idx)
                    break
                }
            }
        }

        // ketika daftarbarang kosong atau tinggal 1
        if self.daftarBarang.count == 1 {
            if self.kapasitas >= self.daftarBarang[0].bobot {
                ambilBarang(x: 0)
            } else {
                hapusBarang(x: 0)
            }
        }

        self.printDaftarBarangJarahan() // tampilkan barang hasil jarahan
    }
}

// MAIN PROGRAM
var problem = KnapsackProblem() // inisialisasi knapsack
problem.findSolution() // cari solusi