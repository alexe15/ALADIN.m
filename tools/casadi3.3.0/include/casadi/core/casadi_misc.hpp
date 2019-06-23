/*
 *    This file is part of CasADi.
 *
 *    CasADi -- A symbolic framework for dynamic optimization.
 *    Copyright (C) 2010-2014 Joel Andersson, Joris Gillis, Moritz Diehl,
 *                            K.U. Leuven. All rights reserved.
 *    Copyright (C) 2011-2014 Greg Horn
 *
 *    CasADi is free software; you can redistribute it and/or
 *    modify it under the terms of the GNU Lesser General Public
 *    License as published by the Free Software Foundation; either
 *    version 3 of the License, or (at your option) any later version.
 *
 *    CasADi is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *    Lesser General Public License for more details.
 *
 *    You should have received a copy of the GNU Lesser General Public
 *    License along with CasADi; if not, write to the Free Software
 *    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */


#ifndef CASADI_MISC_HPP
#define CASADI_MISC_HPP

#include "exception.hpp"
#include "casadi_common.hpp"

/** \brief Convenience tools for C++ Standard Library vectors
    \author Joel Andersson
    \date 2010-2011
*/

namespace casadi {

#ifndef SWIG
  /**  \brief Range function
  * \param start
  * \param stop
  * \param step
  * \param len
  *
  * Consider a infinitely long list [start, start+step, start+2*step, ...]
  * Elements larger than or equal to stop are chopped off.
  *
  */
  CASADI_EXPORT std::vector<int> range(int start, int stop, int step=1,
                                                int len=std::numeric_limits<int>::max());

  CASADI_EXPORT std::string join(const std::vector<std::string>& l, const std::string& delim=",");

  /**  \brief Range function
  * \param stop
  *
  * \return list [0, 1, 2...stop-1]
  */
  CASADI_EXPORT std::vector<int> range(int stop);

  CASADI_EXPORT bool is_equally_spaced(const std::vector<double> &v);

  /**  \brief Slicing vector
  *  \param v Vector to slice
  *  \param i List of indices
  */
  template<typename T>
  std::vector<T> vector_slice(const std::vector<T> &v, const std::vector<int> &i);

  /** \brief Reverse a list
  */
  template<typename T>
  std::vector<T> reverse(const std::vector<T> &v);

  /** \brief Join two lists
  */
  template<typename T>
  std::vector<T> join(const std::vector<T> &a, const std::vector<T> &b);

  #endif // SWIG

  /// Check if for each element of v holds: v_i < upper
  template<typename T>
  bool in_range(const std::vector<T> &v, int upper);

  /// Check if for each element of v holds: lower <= v_i < upper
  template<typename T>
  bool in_range(const std::vector<T> &v, int lower, int upper);

  // Assert that a indices are in a range
  #define casadi_assert_in_range(v, lower, upper) \
   casadi_assert(in_range(v, lower, upper), \
    "Out of bounds error. Got elements in range [" \
    + str(*std::min_element(v.begin(), v.end())) + ","\
    + str(*std::max_element(v.begin(), v.end())) + "], which is outside the range ["\
    + str(lower) + "," + str(upper) + ").")

    // Assert that a indices are bounded
    #define casadi_assert_bounded(v, upper) \
     casadi_assert(in_range(v, upper), \
      "Out of bounds error. Got elements in range [" \
      + str(*std::min_element(v.begin(), v.end())) + ","\
      + str(*std::max_element(v.begin(), v.end())) + "], which exceeds the upper bound "\
      + str(upper) + ".")

  /** \brief Returns the list of all i in [0, size[ not found in supplied list
  *
  * The supplied vector may contain duplicates and may be non-monotonous
  * The supplied vector will be checked for bounds
  * The result vector is guaranteed to be monotonously increasing
  */
  CASADI_EXPORT std::vector<int> complement(const std::vector<int> &v, int size);

  /** \brief Returns a vector for quickly looking up entries of supplied list
  *
  *  lookupvector[i]!=-1     <=>  v contains i
  *  v[lookupvector[i]] == i <=>  v contains i
  *
  *  Duplicates are treated by looking up last occurrence
  */
  CASADI_EXPORT std::vector<int> lookupvector(const std::vector<int> &v, int size);
  CASADI_EXPORT std::vector<int> lookupvector(const std::vector<int> &v);

  /// \cond INTERNAL
#ifndef SWIG
  /**
  Apply a function f to each element in a vector
  */
  template<class T>
  std::vector<T> applymap(T (*f)(const T&), const std::vector<T>&);

  /**
  Apply a function f to each element in a vector
  */
  template<class T>
  void applymap(void (*f)(T&), std::vector<T>&);
#endif // SWIG
  /// \endcond


  /// Check if the vector is strictly increasing
  template<typename T>
  bool is_increasing(const std::vector<T> &v);

  /// Check if the vector is strictly decreasing
  template<typename T>
  bool is_decreasing(const std::vector<T> &v);

  /// Check if the vector is non-increasing
  template<typename T>
  bool is_nonincreasing(const std::vector<T> &v);

  /// Check if the vector is non-decreasing
  template<typename T>
  bool is_nondecreasing(const std::vector<T> &v);

  /// Check if the vector is monotone
  template<typename T>
  bool is_monotone(const std::vector<T> &v);

  /// Check if the vector is strictly monotone
  template<typename T>
  bool is_strictly_monotone(const std::vector<T> &v);

  /// Check if the vector has negative entries
  template<typename T>
  bool has_negative(const std::vector<T> &v);

  /// Print vector, matlab style
  template<typename T>
  void write_matlab(std::ostream &stream, const std::vector<T> &v);

  /// Print matrix, matlab style
  template<typename T>
  void write_matlab(std::ostream &stream, const std::vector<std::vector<T> > &v);

  /// Read vector, matlab style
  template<typename T>
  void read_matlab(std::istream &stream, std::vector<T> &v);

  /// Read matrix, matlab style
  template<typename T>
  void read_matlab(std::ifstream &file, std::vector<std::vector<T> > &v);

#ifndef SWIG
  /// Matlab's linspace
  template<typename T, typename F, typename L>
  void linspace(std::vector<T> &v, const F& first, const L& last);

  /// \cond INTERNAL
  /// Get an pointer of sets of booleans from a double vector
  CASADI_EXPORT bvec_t* get_bvec_t(std::vector<double>& v);

  /// Get an pointer of sets of booleans from a double vector
  CASADI_EXPORT const bvec_t* get_bvec_t(const std::vector<double>& v);

  /// Get an pointer of sets of booleans from a double vector
  template<typename T>
  bvec_t* get_bvec_t(std::vector<T>& v);

  /// Get an pointer of sets of booleans from a double vector
  template<typename T>
  const bvec_t* get_bvec_t(const std::vector<T>& v);

  /// Get a pointer to the data contained in the vector
  template<typename T>
  T* get_ptr(std::vector<T> &v);

  /// Get a pointer to the data contained in the vector
  template<typename T>
  const T* get_ptr(const std::vector<T> &v);

  /// \endcond

  /** \brief Sort the data in a vector
  *
  * \param[in]  values the vector that needs sorting
  * \param[out] sorted_values the sorted vector
  * \param[out] indices The indices such that 'sorted_values= values[indices]'
  * \param[in] invert_indices Output indices such that 'sorted_values[indices=values'
  **/
  template<typename T>
  void sort(const std::vector<T> &values, std::vector<T> &sorted_values, std::vector<int> &indices,
            bool invert_indices =false);

  /** \brief product
  *
  */
  template<typename T>
  T product(const std::vector<T> &values);

  /** \brief cumulative sum
  *
  */
  template<typename T>
  std::vector<T> cumsum(const std::vector<T> &values);

  /** \brief cumulative sum, starting with zero
  *
  */
  template<typename T>
  std::vector<T> cumsum0(const std::vector<T> &values);
#endif //SWIG

  /// Checks if array does not contain NaN or Inf
  template<typename T>
  bool is_regular(const std::vector<T> &v) {
    for (auto&& vk : v) {
      if (vk!=vk || vk==std::numeric_limits<T>::infinity() ||
          vk==-std::numeric_limits<T>::infinity()) return false;
    }
    return true;
  }

  // Create a temporary file
  CASADI_EXPORT std::string temporary_file(const std::string& prefix, const std::string& suffix);

} // namespace casadi

#ifndef SWIG
// In std namespace
namespace std {

  /// Enables flushing an std::vector to a stream (prints representation)
  template<typename T>
  ostream& operator<<(ostream& stream, const vector<T>& v) {
    stream << casadi::str(v);
    return stream;
  }

  /// Enables flushing an std::set to a stream (prints representation)
  template<typename T>
  ostream& operator<<(ostream& stream, const set<T>& v) {
    stream << casadi::str(v);
    return stream;
  }

  template<typename T1, typename T2>
  ostream& operator<<(ostream& stream, const pair<T1, T2>& p) {
    stream << casadi::str(p);
    return stream;
  }

  template<typename T1, typename T2>
  ostream& operator<<(ostream& stream, const std::map<T1, T2>& p) {
    stream << casadi::str(p);
    return stream;
  }

  template<typename T2>
  ostream& operator<<(ostream& stream, const std::map<std::string, T2>& p) {
    stream << casadi::str(p);
    return stream;
  }

} // namespace std

// Implementations
namespace casadi {

  template<typename T>
  std::vector<T> vector_slice(const std::vector<T> &v, const std::vector<int> &i) {
    std::vector<T> ret;
    ret.reserve(i.size());
    for (int k=0;k<i.size();++k) {
       int j = i[k];
       casadi_assert(j>=0,
         "vector_slice: Indices should be larger than zero."
         "You have " + str(j) + " at location " + str(k) + ".");
       casadi_assert(j<v.size(),
         "vector_slice: Indices should be larger than zero."
         "You have " + str(j) + " at location " + str(k) + ".");
       ret.push_back(v[j]);
    }
    return ret;
  }

  template<typename T>
  std::vector<T> reverse(const std::vector<T> &v) {
    std::vector<T> ret(v.size());
    std::reverse_copy(v.begin(), v.end(), ret.begin());
    return ret;
  }

  template<typename T>
  std::vector<T> join(const std::vector<T> &a, const std::vector<T> &b) {
    std::vector<T> ret = a;
    ret.insert(ret.end(), b.begin(), b.end());
    return ret;
  }

#ifndef SWIG
  template<class T>
  std::vector<T> applymap(T (*f)(const T&) , const std::vector<T>& comp) {
    std::vector<T> ret(comp.size());
    std::transform(comp.begin(), comp.end(), ret.begin(), f);
    return ret;
  }

  template<class T>
  void applymap(void (*f)(T &), std::vector<T>& comp) {
    std::for_each(comp.begin(), comp.end(), f);
  }
#endif //SWIG

  template<typename T>
  bool in_range(const std::vector<T> &v, int upper) {
    return in_range(v, 0, upper);
  }

  template<typename T>
  bool in_range(const std::vector<T> &v, int lower, int upper) {
    if (v.size()==0) return true;
    int max = *std::max_element(v.begin(), v.end());
    if (max >= upper) return false;
    int min = *std::min_element(v.begin(), v.end());
    return (min >= lower);
  }

  template<typename T>
  bool isUnique(const std::vector<T> &v) {
    std::set<T> s(v.begin(), v.end());
    return v.size()==s.size();
  }

  template<typename T>
  bool is_increasing(const std::vector<T> &v) {
    if (v.size()==0) return true;
    T el = v[0];
    for (int i=1;i<v.size();++i) {
      if (!(v[i] > el)) return false;
      el = v[i];
    }
    return el==el; // nan -> false
  }

  template<typename T>
  bool is_decreasing(const std::vector<T> &v) {
    if (v.size()==0) return true;
    T el = v[0];
    for (int i=1;i<v.size();++i) {
      if (!(v[i] < el)) return false;
      el = v[i];
    }
    return el==el; // nan -> false
  }

  template<typename T>
  bool is_nonincreasing(const std::vector<T> &v) {
    if (v.size()==0) return true;
    T el = v[0];
    for (int i=1;i<v.size();++i) {
      if (!(v[i] <= el)) return false;
      el = v[i];
    }
    return el==el; // nan -> false
  }

  template<typename T>
  bool is_nondecreasing(const std::vector<T> &v) {
    if (v.size()==0) return true;
    T el = v[0];
    for (int i=1;i<v.size();++i) {
      if (!(v[i] >= el)) return false;
      el = v[i];
    }
    return el==el; // nan -> false
  }

  template<typename T>
  bool is_monotone(const std::vector<T> &v) {
    return is_nondecreasing(v) || is_nonincreasing(v);
  }

  template<typename T>
  bool is_strictly_monotone(const std::vector<T> &v) {
    return is_decreasing(v) || is_increasing(v);
  }

  template<typename T>
  bool has_negative(const std::vector<T> &v) {
    for (std::size_t i=0; i<v.size(); ++i) {
      if (v[i]<0) return true;
    }
    return false;
  }

  template<typename T>
  void write_matlab(std::ostream &stream, const std::vector<T> &v) {
    std::copy(v.begin(), v.end(), std::ostream_iterator<T>(stream, " "));
  }

  template<typename T>
  void write_matlab(std::ostream &stream, const std::vector<std::vector<T> > &v) {
    for (unsigned int i=0; i<v.size(); ++i) {
      std::copy(v[i].begin(), v[i].end(), std::ostream_iterator<T>(stream, " "));
      stream << std::endl;
    }
  }

  template<typename T>
  void read_matlab(std::istream &stream, std::vector<T> &v) {
    v.clear();

    while (!stream.eof()) {
      T val;
      stream >> val;
      if (stream.fail()) {
        stream.clear();
        std::string s;
        stream >> s;
        if (s.compare("inf") == 0)
          val = std::numeric_limits<T>::infinity();
        else
          break;
      }
      v.push_back(val);
    }
  }

  template<typename T>
  void read_matlab(std::ifstream &file, std::vector<std::vector<T> > &v) {
    v.clear();
    std::string line;
    while (!getline(file, line, '\n').eof()) {
      std::istringstream reader(line);
      std::vector<T> lineData;

      while (!reader.eof()) {
        T val;
        reader >> val;
        if (reader.fail()) {
          reader.clear();
          std::string s;
          reader >> s;
          if (s.compare("inf") == 0)
            val = std::numeric_limits<T>::infinity();
          else
            break;
        }
        lineData.push_back(val);
      }
      v.push_back(lineData);
    }
  }

  template<typename T, typename F, typename L>
  void linspace(std::vector<T> &v, const F& first, const L& last) {
    if (v.size()<2)
        throw CasadiException("std::linspace: vector must contain at least two elements");

    // Increment
    T increment = (last-first)/T(v.size()-1);

    v[0] = first;
    for (unsigned i=1; i<v.size()-1; ++i)
      v[i] = v[i-1] + increment;
    v[v.size()-1] = last;
  }

  template<typename T>
  T* get_ptr(std::vector<T> &v) {
    if (v.empty())
      return 0;
    else
      return &v.front();
  }

  template<typename T>
  const T* get_ptr(const std::vector<T> &v) {
    if (v.empty())
      return 0;
    else
      return &v.front();
  }

  // Helper class
  template<typename T>
  struct sortCompare {
    const std::vector<T> &v_;
    sortCompare(const std::vector<T> &v) : v_(v) {}
    bool operator() (int i, int j) const { return v_[i]<v_[j];}
  };

  template<typename T>
  void sort(const std::vector<T> &values, std::vector<T> &sorted_values,
            std::vector<int> &indices, bool invert_indices) {
    // Call recursively if indices need to be inverted
    if (invert_indices) {
      std::vector<int> inverted;
      sort(values, sorted_values, inverted, false);
      indices.resize(inverted.size());
      for (size_t i=0; i<inverted.size(); ++i) {
        indices[inverted[i]] = i;
      }
      return;
    }

    // Create list of indices
    indices.resize(values.size());
    for (size_t i=0; i<indices.size(); ++i) indices[i] = i;

    // Sort this list by the values
    std::sort(indices.begin(), indices.end(), sortCompare<T>(values));

    // Sort the values accordingly
    sorted_values.resize(values.size());
    for (size_t i=0; i<values.size(); ++i) {
      sorted_values[i] = values[indices[i]];
    }
  }

  template<typename T>
  T product(const std::vector<T> &values) {
    T r = 1;
    for (int i=0;i<values.size();++i) r*=values[i];
    return r;
  }

  template<typename T>
  std::vector<T> cumsum(const std::vector<T> &values) {
    std::vector<T> ret(values.size());
    T acc = 0;
    for (int i=0;i<values.size();++i) {
      acc+= values[i];
      ret[i] = acc;
    }
    return ret;
  }

  template<typename T>
  std::vector<T> cumsum0(const std::vector<T> &values) {
    std::vector<T> ret(values.size()+1, 0);
    T acc = 0;
    for (int i=0;i<values.size();++i) {
      acc+= values[i];
      ret[i+1] = acc;
    }
    return ret;
  }

  template<typename T>
  T dot(const std::vector<T>& a, const std::vector<T>& b) {
    T ret = 0;
    for (int k=0; k<a.size(); ++k) {
      ret += a[k]*b[k];
    }
    return ret;
  }

  template<typename T>
  T norm_inf(const std::vector<T>& x) {
    T ret = 0;
    for (int k=0; k<x.size(); ++k) {
      ret = fmax(ret, fabs(x[k]));
    }
    return ret;
  }

  template<typename T>
  T norm_1(const std::vector<T>& x) {
    T ret = 0;
    for (int k=0; k<x.size(); ++k) {
      ret += fabs(x[k]);
    }
    return ret;
  }

  template<typename T>
  T norm_2(const std::vector<T>& x) {
    T ret = 0;
    for (int k=0; k<x.size(); ++k) {
      ret += x[k]*x[k];
    }
    return sqrt(ret);
  }

  template<typename T>
  bvec_t* get_bvec_t(std::vector<T>& v) {
    casadi_assert(0, "get_bvec_t only supported for double");
  }

  template<typename T>
  const bvec_t* get_bvec_t(const std::vector<T>& v) {
    casadi_assert(0, "get_bvec_t only supported for double");
  }

  ///@{
  /// Readability typedefs
  typedef std::vector<std::string> StringVector;
  ///@}

} // namespace casadi
#endif // SWIG

#endif // CASADI_MISC_HPP
